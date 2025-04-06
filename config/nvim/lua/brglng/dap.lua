local M = {}

function M.start_debugging()
    local dap = require("dap")
    local cwd = vim.fn.getcwd()
    local paths = {
        cwd .. "/.nvim/dap.lua",
        cwd .. "/.vim/dap.lua",
        cwd .. "/dap.lua",
    }
    local ok = false
    local config = nil
    for _, path in pairs(paths) do
        ok, config = pcall(dofile, path)
        if ok then
            break
        end
    end
    dap.configurations[vim.o.filetype] = config
    dap.continue()
    require("dapui").open()
end

return M
