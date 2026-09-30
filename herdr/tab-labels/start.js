"use strict";

const fs = require("node:fs");
const os = require("node:os");
const path = require("node:path");
const { spawn } = require("node:child_process");

function processIsRunning(pid) {
  if (!Number.isInteger(pid) || pid <= 0) return false;
  try {
    process.kill(pid, 0);
    return true;
  } catch (error) {
    return error.code === "EPERM";
  }
}

function readPid(pidPath) {
  try {
    return Number.parseInt(fs.readFileSync(pidPath, "utf8").trim(), 10);
  } catch {
    return null;
  }
}

function startWatcher() {
  const pluginRoot = process.env.HERDR_PLUGIN_ROOT || __dirname;
  const stateDir = process.env.HERDR_PLUGIN_STATE_DIR ||
    path.join(os.homedir(), ".config", "herdr", "plugin-state", "brglng.tab-labels");
  const pidPath = path.join(stateDir, "watcher.pid");
  fs.mkdirSync(stateDir, { recursive: true });

  const currentPid = readPid(pidPath);
  if (processIsRunning(currentPid)) return false;
  if (currentPid !== null) fs.unlinkSync(pidPath);

  let descriptor;
  try {
    descriptor = fs.openSync(pidPath, "wx", 0o600);
    fs.writeSync(descriptor, `${process.pid}\n`);
  } catch (error) {
    if (error.code === "EEXIST") return false;
    throw error;
  } finally {
    if (descriptor !== undefined) fs.closeSync(descriptor);
  }

  const child = spawn(process.execPath, [path.join(pluginRoot, "watcher.js")], {
    detached: true,
    env: process.env,
    stdio: "ignore",
  });
  child.once("spawn", () => {
    fs.writeFileSync(pidPath, `${child.pid}\n`, { mode: 0o600 });
    child.unref();
  });
  child.once("error", () => {
    if (readPid(pidPath) === process.pid) fs.unlinkSync(pidPath);
  });
  return true;
}

if (require.main === module) startWatcher();

module.exports = { processIsRunning, startWatcher };
