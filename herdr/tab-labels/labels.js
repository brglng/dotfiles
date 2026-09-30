"use strict";

function unwrapSnapshot(response) {
  if (response?.result?.snapshot) return response.result.snapshot;
  if (response?.snapshot) return response.snapshot;
  return response;
}

function labelsForSnapshot(response) {
  const snapshot = unwrapSnapshot(response);
  if (
    !snapshot ||
    !Array.isArray(snapshot.tabs) ||
    !Array.isArray(snapshot.panes) ||
    !Array.isArray(snapshot.layouts)
  ) {
    throw new TypeError("Expected a Herdr snapshot with tabs, panes, and layouts.");
  }

  const panesById = new Map(snapshot.panes.map((pane) => [pane.pane_id, pane]));
  const layoutsByTabId = new Map(snapshot.layouts.map((layout) => [layout.tab_id, layout]));
  const positionsByWorkspaceId = new Map();
  const labels = new Map();

  for (const tab of snapshot.tabs) {
    const position = (positionsByWorkspaceId.get(tab.workspace_id) || 0) + 1;
    positionsByWorkspaceId.set(tab.workspace_id, position);

    const focusedPaneId = layoutsByTabId.get(tab.tab_id)?.focused_pane_id;
    const terminalTitle = panesById.get(focusedPaneId)?.terminal_title;
    const label = typeof terminalTitle === "string" && terminalTitle.length > 0
      ? `${position} ${terminalTitle}`
      : String(position);
    labels.set(tab.tab_id, label);
  }

  return labels;
}

async function reconcileTabLabels(response, renameTab) {
  const snapshot = unwrapSnapshot(response);
  const labels = labelsForSnapshot(snapshot);
  let renamed = 0;

  for (const tab of snapshot.tabs) {
    const label = labels.get(tab.tab_id);
    if (tab.label === label) continue;
    if (await renameTab(tab.tab_id, label) !== false) renamed += 1;
  }

  return renamed;
}

module.exports = { labelsForSnapshot, reconcileTabLabels, unwrapSnapshot };
