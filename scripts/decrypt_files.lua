--- Decrypt files by reading through Neovim (which has transparent decryption
--- permission from the encryption software), writing the decrypted bytes to
--- a temp file, then atomically replacing the original.
---
--- Usage:
---   nvim --headless -l decrypt_files.lua [item ...] [-R dir ...] ...
---
--- Arguments:
---   file        Process this single file.
---   dir         Process only top-level files in this directory (non-recursive).
---   -R dir      Process all files in this directory recursively.
---
--- The -R flag applies only to the next argument.  Each directory that
--- needs recursion must have its own -R prefix.  File arguments are always
--- processed as-is regardless of whether -R precedes them.
---
--- Examples:
---   nvim -l decrypt_files.lua scripts/util.sh
---   nvim -l decrypt_files.lua -R scripts pi
---   nvim -l decrypt_files.lua file1 -R dir1 dir2 -R dir3
---
--- Everything runs inside the Neovim process via libuv (vim.uv), so the
--- encryption software's process-based decryption applies to all I/O.

local uv = vim.uv or vim.loop

local TMP_SUFFIX = ".decrypt_tmp"
local CHUNK = 50 -- print progress every N files

--- Collect regular files from a directory, optionally recursing into subdirs.
--- @param dir string
--- @param recursive boolean
--- @param acc string[]?
--- @return string[]
local function collect_files(dir, recursive, acc)
  acc = acc or {}
  local handle = uv.fs_scandir(dir)
  if not handle then
    return acc
  end
  while true do
    local name, ftype = uv.fs_scandir_next(handle)
    if not name then
      break
    end
    local path = dir .. "/" .. name
    if ftype == "directory" then
      if recursive then
        collect_files(path, true, acc)
      end
    elseif ftype == "file" then
      acc[#acc + 1] = path
    elseif ftype == "link" then
      -- Resolve symlink target; collect if it points to a regular file,
      -- or recurse if it points to a directory (when recursive).
      local stat = uv.fs_stat(path)
      if stat and stat.type == "file" then
        acc[#acc + 1] = path
      elseif stat and stat.type == "directory" and recursive then
        collect_files(path, true, acc)
      end
    end
  end
  return acc
end

--- Read entire file as binary string.
--- @param path string
--- @return string? data, string? err
local function read_file(path)
  local fd, err = uv.fs_open(path, "r", 438) -- 0o666
  if not fd then
    return nil, err
  end
  local stat, serr = uv.fs_fstat(fd)
  if not stat then
    uv.fs_close(fd)
    return nil, serr
  end
  local data, derr = uv.fs_read(fd, stat.size, 0)
  uv.fs_close(fd)
  if not data then
    return nil, derr
  end
  return data
end

--- Write binary data to a file, preserving the given mode.
--- @param path string
--- @param data string
--- @param mode integer?
--- @return boolean ok, string? err
local function write_file(path, data, mode)
  local fd, err = uv.fs_open(path, "w", mode or 438)
  if not fd then
    return false, err
  end
  local ok, werr = uv.fs_write(fd, data, 0)
  uv.fs_close(fd)
  if not ok then
    return false, werr
  end
  return true
end

--- Process a single file: read (decrypt) -> write temp -> rename over original.
--- @param file string
--- @return boolean ok, string? err
local function process_file(file)
  -- 1. Read original file; Neovim process triggers transparent decryption.
  local data, rerr = read_file(file)
  if not data then
    return false, "read: " .. (rerr or "unknown")
  end

  -- Preserve original file mode for the replacement.
  local stat = uv.fs_stat(file)
  local mode = stat and stat.mode or 438

  -- 2. Write decrypted bytes to a temp file in the same directory
  --    (same filesystem => fs_rename is atomic).
  local tmp = file .. TMP_SUFFIX
  local wok, werr = write_file(tmp, data, mode)
  if not wok then
    return false, "temp write: " .. (werr or "unknown")
  end

  -- 3. Atomically replace the original with the temp file.
  local rok, rerr2 = uv.fs_rename(tmp, file)
  if not rok then
    -- Fallback: overwrite the original directly, then clean up temp.
    local ok2, e2 = write_file(file, data, mode)
    uv.fs_unlink(tmp)
    if not ok2 then
      return false, "rename failed (" .. (rerr2 or "?") .. ") and overwrite also failed: " .. (e2 or "?")
    end
    return true
  end

  return true
end

-- ---------------------------------------------------------------------------
-- Argument parsing
-- ---------------------------------------------------------------------------

local argv = arg or {}
local targets = {} --- @type {path: string, recursive: boolean}[]
local pending_recursive = false

for i = 1, #argv do
  local a = argv[i]
  if a == "-R" or a == "--recursive" then
    pending_recursive = true
  else
    targets[#targets + 1] = { path = a, recursive = pending_recursive }
    pending_recursive = false
  end
end

if pending_recursive then
  print("[decrypt] Error: -R at end of arguments with no following path.")
  vim.cmd("cquit 1")
end

if #targets == 0 then
  print([[
[decrypt] Usage: nvim -l decrypt_files.lua [item ...] [-R dir ...] ...
  file        Process this single file.
  dir         Process only top-level files in this directory.
  -R dir      Process all files in this directory recursively.

Examples:
  nvim -l decrypt_files.lua scripts/util.sh
  nvim -l decrypt_files.lua -R scripts pi
  nvim -l decrypt_files.lua file1 -R dir1 dir2 -R dir3]])
  vim.cmd("qa!")
  return
end

-- ---------------------------------------------------------------------------
-- Build file list from targets (deduplicated)
-- ---------------------------------------------------------------------------

local seen = {} --- @type table<string, boolean>
local files = {}
local skipped = {}

for _, t in ipairs(targets) do
  local stat = uv.fs_stat(t.path)
  if not stat then
    skipped[#skipped + 1] = t.path .. " (not found)"
  elseif stat.type == "file" then
    if not seen[t.path] then
      seen[t.path] = true
      files[#files + 1] = t.path
    end
  elseif stat.type == "directory" then
    local collected = collect_files(t.path, t.recursive)
    for _, f in ipairs(collected) do
      if not seen[f] then
        seen[f] = true
        files[#files + 1] = f
      end
    end
  else
    skipped[#skipped + 1] = t.path .. " (" .. stat.type .. ", not a file or directory)"
  end
end

local total = #files
print(string.format("[decrypt] Found %d files", total))
if #skipped > 0 then
  for _, s in ipairs(skipped) do
    print("[decrypt] Skipped: " .. s)
  end
end

if total == 0 then
  print("[decrypt] Nothing to do.")
  vim.cmd("qa!")
  return
end

-- ---------------------------------------------------------------------------
-- Process files
-- ---------------------------------------------------------------------------

local ok_count = 0
local fail_count = 0
local errors = {}

for i, file in ipairs(files) do
  local ok, err = process_file(file)
  if ok then
    ok_count = ok_count + 1
  else
    fail_count = fail_count + 1
    errors[#errors + 1] = string.format("  %s — %s", file, err or "unknown")
  end

  if i % CHUNK == 0 then
    print(string.format("  [%d/%d] ...", i, total))
  end
end

print(string.format("\n[decrypt] Done: %d ok, %d failed (total %d)", ok_count, fail_count, total))

if #errors > 0 then
  print("[decrypt] Failures:")
  for _, e in ipairs(errors) do
    print(e)
  end
end

-- Exit with non-zero code if any file failed (useful in headless mode).
if fail_count > 0 then
  vim.cmd("cquit 1")
else
  vim.cmd("qa!")
end
