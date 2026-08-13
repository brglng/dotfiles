-- Renders the `<available_skills>` block for Pi skills, mirroring the exact
-- format that Pi itself injects into its own system prompt (see
-- pi-coding-agent's dist/core/skills.js formatSkillsForPrompt). This lets
-- non-Pi LLMs (e.g. HTTP adapters in CodeCompanion) discover the skills and
-- read the full SKILL.md on demand via a file-reading tool.

---@class brglng.Skill
---@field name string
---@field description string
---@field location string

local M = {}

---@return string
local function skills_root()
  return vim.env.BRGLNG_DOTFILES_DIR .. "/pi/agent/skills"
end

---Parse the `name` and `description` fields out of a SKILL.md frontmatter block.
---@param filepath string
---@return brglng.Skill|nil
local function parse_skill(filepath)
  local ok, lines = pcall(vim.fn.readfile, filepath)
  if not ok or type(lines) ~= "table" or #lines == 0 or lines[1] ~= "---" then
    return nil
  end

  local name, description
  for i = 2, #lines do
    local line = lines[i]
    if line == "---" then
      break
    end
    local key, value = line:match("^([%w-_]+):%s*(.-)%s*$")
    if key == "name" then
      name = value
    elseif key == "description" then
      description = value
    end
  end

  if not name or not description then
    return nil
  end

  return { name = name, description = description, location = filepath }
end

---Collect all skills found in the Pi skills directory.
---@return brglng.Skill[]
local function collect_skills()
  local skills = {}
  local dirs = vim.fn.glob(skills_root() .. "/*", false, true)
  for _, dir in ipairs(dirs) do
    if vim.fn.isdirectory(dir) == 1 then
      local skill_file = dir .. "/SKILL.md"
      if vim.fn.filereadable(skill_file) == 1 then
        local skill = parse_skill(skill_file)
        if skill then
          table.insert(skills, skill)
        end
      end
    end
  end
  table.sort(skills, function(a, b)
    return a.name < b.name
  end)
  return skills
end

---Escape a string for use inside XML element content.
---@param s string
---@return string
local function escape_xml(s)
  return (s:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"))
end

---Render the `<available_skills>` block (empty string if no skills found).
---@return string
function M.render_available_skills()
  local skills = collect_skills()
  if #skills == 0 then
    return ""
  end

  local lines = {
    "",
    "The following skills provide specialized instructions for specific tasks.",
    "Use a file-reading tool to load a skill's file when the task matches its description.",
    "When a skill file references a relative path, resolve it against the skill directory (parent of SKILL.md / dirname of the path) and use that absolute path in tool calls.",
    "",
    "<available_skills>",
  }

  for _, skill in ipairs(skills) do
    lines[#lines + 1] = "  <skill>"
    lines[#lines + 1] = "    <name>" .. escape_xml(skill.name) .. "</name>"
    lines[#lines + 1] = "    <description>" .. escape_xml(skill.description) .. "</description>"
    lines[#lines + 1] = "    <location>" .. escape_xml(skill.location) .. "</location>"
    lines[#lines + 1] = "  </skill>"
  end

  lines[#lines + 1] = "</available_skills>"
  return table.concat(lines, "\n")
end

return M
