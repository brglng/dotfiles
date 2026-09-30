"use strict";

const assert = require("node:assert/strict");
const fs = require("node:fs");
const { EventEmitter } = require("node:events");
const os = require("node:os");
const path = require("node:path");
const test = require("node:test");
const { labelsForSnapshot, reconcileTabLabels } = require("../labels");
const {
  createEventLineHandler,
  shouldReconcile,
  startWatcher,
  watchPluginRegistry,
} = require("../watcher");

function makeSnapshot() {
  return {
    tabs: [
      { tab_id: "ws-a:t1", workspace_id: "ws-a", label: "old" },
      { tab_id: "ws-b:t1", workspace_id: "ws-b", label: "1 build" },
      { tab_id: "ws-a:t2", workspace_id: "ws-a", label: "old" },
      { tab_id: "ws-a:t3", workspace_id: "ws-a", label: "old" },
    ],
    panes: [
      { pane_id: "a:p1", terminal_title: "" },
      { pane_id: "a:p3", terminal_title: "editor" },
      { pane_id: "b:p1", terminal_title: "build" },
    ],
    layouts: [
      { tab_id: "ws-a:t1", focused_pane_id: "a:p1" },
      { tab_id: "ws-a:t2", focused_pane_id: "a:p3" },
      { tab_id: "ws-b:t1", focused_pane_id: "b:p1" },
    ],
  };
}

async function waitFor(predicate) {
  const deadline = Date.now() + 1000;
  while (!predicate()) {
    if (Date.now() >= deadline) throw new Error("Timed out waiting for watcher activity.");
    await new Promise((resolve) => setTimeout(resolve, 10));
  }
}

test("formats workspace-local tab positions with focused pane terminal titles", () => {
  const labels = labelsForSnapshot({ result: { snapshot: makeSnapshot() } });

  assert.deepEqual([...labels], [
    ["ws-a:t1", "1"],
    ["ws-b:t1", "1 build"],
    ["ws-a:t2", "2 editor"],
    ["ws-a:t3", "3"],
  ]);
});

test("reconciliation renames only mismatches and is idempotent", async () => {
  const snapshot = makeSnapshot();
  const calls = [];
  const renameTab = async (tabId, label) => {
    calls.push([tabId, label]);
    snapshot.tabs.find((tab) => tab.tab_id === tabId).label = label;
    return true;
  };

  assert.equal(await reconcileTabLabels(snapshot, renameTab), 3);
  assert.equal(await reconcileTabLabels(snapshot, renameTab), 0);
  assert.deepEqual(calls, [
    ["ws-a:t1", "1"],
    ["ws-a:t2", "2 editor"],
    ["ws-a:t3", "3"],
  ]);
});

test("recognizes tab, pane, and layout updates", () => {
  assert.equal(shouldReconcile({ event: "tab.renamed" }), true);
  assert.equal(shouldReconcile({ event: "tab_renamed" }), true);
  assert.equal(shouldReconcile({ event: "pane.updated" }), true);
  assert.equal(shouldReconcile({ event: "pane.output_changed" }), false);
});

test("parses event messages split across socket chunks", () => {
  const received = [];
  const handleChunk = createEventLineHandler((event) => received.push(event));
  const frames = [
    JSON.stringify({ event: "tab_renamed", data: { type: "tab_renamed" } }),
    JSON.stringify({ event: "pane_updated", data: { type: "pane_updated" } }),
  ].join("\n") + "\n";

  handleChunk(Buffer.from(frames.slice(0, 19)));
  handleChunk(Buffer.from(frames.slice(19)));

  assert.deepEqual(received.map((event) => event.event), ["tab_renamed", "pane_updated"]);
});

test("subscribes and reconciles labels after rename and title events", async () => {
  class FakeSocket extends EventEmitter {
    writes = [];

    write(data) {
      this.writes.push(data);
      return true;
    }

    destroy() {
      this.destroyed = true;
      this.emit("close");
    }
  }

  const socket = new FakeSocket();
  const snapshot = makeSnapshot();
  let snapshotReads = 0;
  let disablePlugin;
  let unwatchCalled = false;
  const stop = startWatcher({
    env: {},
    socketPath: "fake-socket",
    createConnection: () => socket,
    watchPluginState: (_env, onDisabled) => {
      disablePlugin = onDisabled;
      return () => { unwatchCalled = true; };
    },
    getSnapshot: async () => {
      snapshotReads += 1;
      return snapshot;
    },
    renameTab: async (tabId, label) => {
      snapshot.tabs.find((tab) => tab.tab_id === tabId).label = label;
      return true;
    },
  });

  try {
    socket.emit("connect");
    await waitFor(() => snapshotReads === 1 && snapshot.tabs[0].label === "1");
    const subscription = JSON.parse(socket.writes[0]);
    assert.equal(subscription.method, "events.subscribe");
    assert.ok(subscription.params.subscriptions.some(({ type }) => type === "pane.updated"));
    assert.ok(subscription.params.subscriptions.some(({ type }) => type === "tab.renamed"));

    snapshot.tabs[0].label = "external name";
    socket.emit("data", Buffer.from(`${JSON.stringify({ event: "tab_renamed" })}\n`));
    await waitFor(() => snapshotReads === 2 && snapshot.tabs[0].label === "1");

    snapshot.panes.find((pane) => pane.pane_id === "a:p3").terminal_title = "updated title";
    socket.emit("data", Buffer.from(`${JSON.stringify({ event: "pane_updated" })}\n`));
    await waitFor(() => snapshotReads === 3 && snapshot.tabs[2].label === "2 updated title");

    disablePlugin();
    assert.equal(socket.destroyed, true);
    assert.equal(unwatchCalled, true);
  } finally {
    stop();
  }
});

test("stops when the plugin is disabled or removed from its registry", async () => {
  for (const nextPlugins of [
    [{ plugin_id: "brglng.tab-labels", enabled: false }],
    [],
  ]) {
    let plugins = [{ plugin_id: "brglng.tab-labels", enabled: true }];
    let onRegistryChange;
    let disabled = false;
    const fakeWatcher = new EventEmitter();
    fakeWatcher.close = () => { fakeWatcher.closed = true; };

    const stopWatching = watchPluginRegistry(
      { HERDR_CONFIG_PATH: "/fake/herdr/config.toml" },
      () => { disabled = true; },
      {
        readFile: () => JSON.stringify(plugins),
        watchDirectory: (directory, callback) => {
          assert.equal(directory, "/fake/herdr");
          onRegistryChange = callback;
          return fakeWatcher;
        },
      },
    );

    plugins = nextPlugins;
    onRegistryChange("rename", "plugins.json");
    await new Promise((resolve) => setTimeout(resolve, 80));
    assert.equal(disabled, true);
    assert.equal(fakeWatcher.closed, true);
    stopWatching();
  }
});

test("watches the real registry file and stops after disable", async () => {
  const directory = fs.mkdtempSync(path.join(os.tmpdir(), "herdr-tab-labels-test-"));
  const registryPath = path.join(directory, "plugins.json");
  fs.writeFileSync(registryPath, JSON.stringify([
    { plugin_id: "brglng.tab-labels", enabled: true },
  ]));
  let disabled = false;
  const stopWatching = watchPluginRegistry(
    { HERDR_CONFIG_PATH: path.join(directory, "config.toml") },
    () => { disabled = true; },
  );

  try {
    fs.writeFileSync(registryPath, JSON.stringify([
      { plugin_id: "brglng.tab-labels", enabled: false },
    ]));
    await waitFor(() => disabled);
    assert.equal(disabled, true);
  } finally {
    stopWatching();
    fs.rmSync(directory, { recursive: true, force: true });
  }
});
