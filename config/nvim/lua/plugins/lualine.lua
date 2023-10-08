-- require('lsp-progress').setup {}

require('lualine').setup({
    options = {
        globalstatus = true,
    },
    -- extensions = {
    --     "lazy",
    --     "neo-tree",
    --     "quickfix",
    --     "trouble"
    -- },
    sections = {
        lualine_b = {
            "branch",
            "diff",
            {
                "diagnostics",
                sources = { "nvim_diagnostic", "nvim_lsp" },
                sections = { "error", "warn", "info", "hint" },
                symbols = { error = ' ', warn = ' ', info = ' ', hint = ' ' },
            },
        },
        lualine_c = {
            {
                require("noice").api.status.search.get,
                cond = require("noice").api.status.search.has,
            },
            -- "require('lsp-progress').progress()",
        },
        lualine_x = {
            {
                require("noice").api.status.command.get,
                cond = require("noice").api.status.command.has,
                separator = '',
                padding = { right = 3 }
            },
            'encoding',
            'fileformat',
            'filetype',
        },
        lualine_y = {
            "progress",
        },
        lualine_z = {
            { function()
                local is_visual_mode = vim.fn.mode():find("[vVsS]")
                if not is_visual_mode then
                    return ""
                end
                local starts = vim.fn.line("v")
                local ends = vim.fn.line(".")
                local lines = (starts <= ends and ends - starts + 1) or (starts - ends + 1)
                return "󰫙 " .. tostring(lines) .. "," .. tostring(vim.fn.wordcount().visual_chars)
            end },
            { function()
                local line = vim.fn.line('.')
                local col = vim.fn.virtcol('.')
                return string.format(' %3d,%-2d', line, col)
            end }
        }
    }
})

-- listen lsp-progress event and refresh lualine
-- vim.api.nvim_create_augroup("lualine_augroup", { clear = true })
-- vim.api.nvim_create_autocmd("User LspProgressStatusUpdated", {
--     group = "lualine_augroup",
--     callback = require("lualine").refresh,
-- })
