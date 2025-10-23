vim.env.PIXI_IN_SHELL = nil
vim.g.pixi_save_env = {}

local function find_project_root()
    local project_root = vim.fs.root(0, { "pixi.toml" })
    if project_root then
        return vim.fs.normalize(project_root)
    end
end

--- @param project_root? string
local function activate(project_root)
    if vim.env.PIXI_IN_SHELL ~= nil then
        vim.notify("Pixi environment " .. vim.env.PIXI_PROJECT_NAME .. " already activated at " .. vim.env.PIXI_PROJECT_ROOT, vim.log.levels.INFO)
        return
    end
    project_root = project_root or find_project_root()
    if project_root then
        vim.notify("Activating Pixi environment at " .. project_root, vim.log.levels.INFO)
        vim.system({ "pixi", "shell-hook", "--no-progress", "--json" }, { cwd = project_root, text = true }, function(obj)
            vim.schedule(function()
                if obj.code == 0 then
                    if obj.stdout and obj.stdout ~= "" then
                        local json = vim.json.decode(obj.stdout)
                        if json and json.environment_variables then
                            local save_env = {}
                            for k, v in pairs(json.environment_variables) do
                                save_env[k] = vim.env[k] or ""
                                vim.env[k] = v
                            end
                            vim.g.pixi_save_env = save_env
                            local project_name = vim.env.PIXI_PROJECT_NAME or "<NO NAME>"
                            vim.notify("Activated Pixi environment " .. project_name .. " at " .. project_root, vim.log.levels.INFO)
                            for _, v in ipairs({ "basedpyright", "pyrefly", "pyright", "ruff", "ty" }) do
                                if #vim.lsp.get_clients({ name = v }) > 0 then
                                    vim.cmd("LspRestart " .. v)
                                end
                            end
                        else
                            vim.notify("No `environment_variables` field in `pixi shell-hook --json` output", vim.log.levels.WARN)
                        end
                    else
                        vim.notify("No output from `pixi shell-hook --json`", vim.log.levels.WARN)
                    end
                else
                    vim.notify("Command `pixi shell-hook --json` failed with code .. " .. obj.code .. ": " .. obj.stderr, vim.log.levels.ERROR)
                end
            end)
        end)
    end
end

local function deactivate()
    if vim.env.PIXI_IN_SHELL ~= nil then
        local project_name = vim.env.PIXI_PROJECT_NAME or "<NO NAME>"
        local project_root = vim.env.PIXI_PROJECT_ROOT
        vim.notify("Deactivating Pixi environment " .. project_name .. " at " .. project_root, vim.log.levels.INFO)
        for k, v in pairs(vim.g.pixi_save_env) do
            if v == "" then
                vim.env[k] = nil
            else
                vim.env[k] = v
            end
        end
        vim.g.pixi_save_env = {}
        vim.notify("Deactivated Pixi environment " .. project_name .. " at " .. project_root, vim.log.levels.INFO)
        vim.env.PIXI_IN_SHELL = nil
    else
        vim.notify("No Pixi environment to deactivate", vim.log.levels.INFO)
    end
end

local function setup()
    vim.api.nvim_create_user_command("PixiActivate", activate, { desc = "Activate Pixi environment" })
    vim.api.nvim_create_user_command("PixiDeactivate", deactivate, { desc = "Deactivate Pixi environment" })
    vim.api.nvim_create_autocmd({ "BufEnter" }, {
        pattern = "*",
        callback = function()
            if vim.env.PIXI_IN_SHELL ~= nil then
                local root = find_project_root()
                if vim.fs.abspath(vim.fn.resolve(root)) ~= vim.fs.abspath(vim.fn.resolve(vim.env.PIXI_PROJECT_ROOT)) then
                    deactivate()
                    activate(root)
                end
            else
                local root = find_project_root()
                if root then
                    activate(root)
                end
            end
        end
    })
end

return {
    activate = activate,
    deactivate = deactivate,
    get_project_name = function()
        return vim.env.PIXI_PROJECT_NAME or "<NO NAME>"
    end,
    setup = setup,
}
