"use strict";

const fs = require("node:fs");
const net = require("node:net");
const path = require("node:path");
const { spawn } = require("node:child_process");
const { homedir } = require("node:os");
const { reconcileTabLabels, unwrapSnapshot } = require("./labels");

const PLUGIN_ID = "brglng.tab-labels";
const COMMAND_TIMEOUT_MS = 5000;
const MAX_SNAPSHOT_BYTES = 32 * 1024 * 1024;
const REFRESH_DEBOUNCE_MS = 50;
const RECONNECT_DELAY_MS = 1000;

const SUBSCRIPTIONS = [
  "tab.created",
  "tab.closed",
  "tab.moved",
  "tab.renamed",
  "tab.focused",
  "pane.created",
  "pane.closed",
  "pane.updated",
  "pane.focused",
  "pane.moved",
  "layout.updated",
];

const RECONCILE_EVENTS = new Set(SUBSCRIPTIONS.map((event) => event.replace(/\./g, "_")));

function configPathFor(env) {
  const configHome = env.XDG_CONFIG_HOME || path.join(homedir(), ".config");
  return env.HERDR_CONFIG_PATH || path.join(configHome, "herdr", "config.toml");
}

function pluginRegistryPath(env) {
  return path.join(path.dirname(configPathFor(env)), "plugins.json");
}

function socketPathFor(env) {
  return env.HERDR_SOCKET_PATH || path.join(path.dirname(configPathFor(env)), "herdr.sock");
}

function herdrCommand(env) {
  return env.HERDR_BIN_PATH || "herdr";
}

function eventName(message) {
  const name = typeof message?.event === "string"
    ? message.event
    : message?.data?.type;
  return typeof name === "string" ? name.replace(/\./g, "_") : "";
}

function shouldReconcile(message) {
  return RECONCILE_EVENTS.has(eventName(message));
}

function createEventLineHandler(onEvent) {
  let buffer = "";

  return (chunk) => {
    buffer += chunk.toString("utf8");
    let newline;
    while ((newline = buffer.indexOf("\n")) !== -1) {
      const line = buffer.slice(0, newline).trim();
      buffer = buffer.slice(newline + 1);
      if (!line) continue;

      try {
        const message = JSON.parse(line);
        if (shouldReconcile(message)) onEvent(message);
      } catch {
        // Ignore malformed and non-event socket lines.
      }
    }
  };
}

function watchPluginRegistry(env, onDisabled, options = {}) {
  const registryPath = options.registryPath || pluginRegistryPath(env);
  const watchDirectory = options.watchDirectory || fs.watch;
  const readFile = options.readFile || fs.readFileSync;
  const pluginId = env.HERDR_PLUGIN_ID || PLUGIN_ID;
  let watcher;
  let settleTimer;
  let closed = false;

  function close() {
    if (closed) return;
    closed = true;
    clearTimeout(settleTimer);
    watcher?.close();
  }

  function disable() {
    if (closed) return;
    close();
    onDisabled();
  }

  function checkEnabled() {
    let plugins;
    try {
      plugins = JSON.parse(readFile(registryPath, "utf8"));
    } catch {
      disable();
      return;
    }

    const plugin = Array.isArray(plugins)
      ? plugins.find((entry) => entry.plugin_id === pluginId)
      : undefined;
    if (!plugin || plugin.enabled !== true) disable();
  }

  try {
    watcher = watchDirectory(path.dirname(registryPath), (_eventType, filename) => {
      const changedName = filename == null ? null : filename.toString();
      if (changedName !== null && changedName !== path.basename(registryPath)) return;
      clearTimeout(settleTimer);
      settleTimer = setTimeout(checkEnabled, 50);
    });
    watcher.on("error", disable);
  } catch {
    disable();
    return close;
  }

  checkEnabled();
  return close;
}

function createHerdrCommandRunner(env, activeChildren, isStopped, spawnProcess = spawn) {
  return (args, captureStdout = false) => new Promise((resolve, reject) => {
    if (isStopped()) {
      reject(new Error("tab-label watcher stopped"));
      return;
    }

    let child;
    try {
      child = spawnProcess(herdrCommand(env), args, {
        env,
        stdio: captureStdout ? ["ignore", "pipe", "ignore"] : "ignore",
      });
    } catch (error) {
      reject(error);
      return;
    }
    activeChildren.add(child);
    const stdoutChunks = [];
    let stdoutBytes = 0;
    let settled = false;
    const timeout = setTimeout(() => {
      child.kill();
      if (!settled) {
        settled = true;
        activeChildren.delete(child);
        reject(new Error(`Herdr command timed out: ${args.join(" ")}`));
      }
    }, COMMAND_TIMEOUT_MS);

    child.once("error", (error) => {
      clearTimeout(timeout);
      activeChildren.delete(child);
      if (!settled) {
        settled = true;
        reject(error);
      }
    });
    child.once("close", (code) => {
      clearTimeout(timeout);
      activeChildren.delete(child);
      if (settled) return;
      settled = true;
      if (code === 0) resolve(Buffer.concat(stdoutChunks).toString("utf8"));
      else reject(new Error(`Herdr command failed: ${args.join(" ")}`));
    });

    if (captureStdout) {
      child.stdout.on("data", (chunk) => {
        stdoutBytes += chunk.length;
        if (stdoutBytes > MAX_SNAPSHOT_BYTES) {
          child.kill();
          if (!settled) {
            settled = true;
            clearTimeout(timeout);
            activeChildren.delete(child);
            reject(new Error("Herdr snapshot exceeded the output limit."));
          }
          return;
        }
        stdoutChunks.push(chunk);
      });
    }
  });
}

function startWatcher(options = {}) {
  const env = options.env || process.env;
  const connect = options.createConnection || net.createConnection;
  const socketPath = options.socketPath || socketPathFor(env);
  const activeChildren = new Set();
  let socket;
  let connectedOnce = false;
  let stopped = false;
  let unwatchPlugin = () => {};
  let reconnectTimer;
  let refreshTimer;
  let refreshRunning = false;
  let refreshAgain = false;
  const runHerdrCommand = createHerdrCommandRunner(
    env,
    activeChildren,
    () => stopped,
    options.spawnProcess || spawn,
  );
  const getSnapshot = options.getSnapshot || (async () => {
    const output = await runHerdrCommand(["api", "snapshot"], true);
    let response;
    try {
      response = JSON.parse(output);
    } catch {
      throw new Error("Herdr returned invalid snapshot JSON.");
    }
    return unwrapSnapshot(response);
  });
  const renameTab = options.renameTab || (async (tabId, label) => {
    try {
      await runHerdrCommand(["tab", "rename", tabId, label]);
      return true;
    } catch {
      return false;
    }
  });

  async function refresh() {
    if (refreshRunning) {
      refreshAgain = true;
      return;
    }

    refreshRunning = true;
    do {
      refreshAgain = false;
      try {
        const snapshot = await getSnapshot();
        await reconcileTabLabels(snapshot, (tabId, label) =>
          stopped ? false : renameTab(tabId, label));
      } catch {
        // A later event or socket reconnect will retry reconciliation.
      }
    } while (refreshAgain && !stopped);
    refreshRunning = false;
  }

  function stop() {
    if (stopped) return;
    stopped = true;
    clearTimeout(reconnectTimer);
    clearTimeout(refreshTimer);
    unwatchPlugin();
    socket?.destroy();
    for (const child of activeChildren) child.kill();
  }

  function scheduleRefresh() {
    clearTimeout(refreshTimer);
    refreshTimer = setTimeout(() => {
      refreshTimer = undefined;
      void refresh();
    }, REFRESH_DEBOUNCE_MS);
  }

  function reconnect() {
    if (stopped) return;
    if (connectedOnce && !fs.existsSync(socketPath)) {
      stop();
      return;
    }

    let current;
    try {
      current = connect(socketPath);
    } catch {
      reconnectTimer = setTimeout(reconnect, RECONNECT_DELAY_MS);
      return;
    }
    socket = current;
    const handleLine = createEventLineHandler(scheduleRefresh);

    current.on("connect", () => {
      connectedOnce = true;
      current.write(`${JSON.stringify({
        id: `${PLUGIN_ID}:events`,
        method: "events.subscribe",
        params: { subscriptions: SUBSCRIPTIONS.map((type) => ({ type })) },
      })}\n`);
      scheduleRefresh();
    });
    current.on("data", handleLine);
    current.on("error", () => {});
    current.on("close", () => {
      if (socket === current) socket = undefined;
      if (stopped) return;
      if (connectedOnce && !fs.existsSync(socketPath)) {
        stop();
        return;
      }
      reconnectTimer = setTimeout(reconnect, RECONNECT_DELAY_MS);
    });
  }

  const watchPluginState = options.watchPluginState || watchPluginRegistry;
  unwatchPlugin = watchPluginState(env, stop);
  if (stopped) {
    unwatchPlugin();
    return stop;
  }

  reconnect();
  return stop;
}

if (require.main === module) startWatcher();

module.exports = {
  SUBSCRIPTIONS,
  createEventLineHandler,
  createHerdrCommandRunner,
  eventName,
  herdrCommand,
  pluginRegistryPath,
  shouldReconcile,
  socketPathFor,
  startWatcher,
  watchPluginRegistry,
};
