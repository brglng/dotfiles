return {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    lazy = true,
    dependencies = {
        "echasnovski/mini.icons",
    },
    opts = {
        options = {
            disabled_filetypes = {
                statusline = { "alpha" },
                winbar = { "alpha" },
            },
            globalstatus = true,
            -- component_separators = "│",
            -- component_separators = "|",
            -- section_separators = { left = '', right = '' },
        },
        -- extensions = {
        --     "lazy",
        --     "neo-tree",
        --     "quickfix",
        --     "trouble"
        -- },
        sections = {
            -- lualine_a =  { separator = { left = '' }, right_padding = 2 },
            lualine_b = {
                "branch",
                "diff",
                {
                    "diagnostics",
                    sources = { "nvim_diagnostic", "nvim_lsp" },
                    sections = { "error", "warn", "info", "hint" },
                    symbols = { Error = " ", Warn = " ", Info = " ", Hint = "󰌶 " },
                },
            },
            lualine_c = {
                {
                    function()
                        local clients = vim.lsp.get_clients()
                        local buf = vim.api.nvim_get_current_buf()
                        clients = vim.iter(clients)
                            :filter(function(client)
                                return client.attached_buffers[buf]
                            end)
                            :filter(function(client)
                                return client.name ~= "Codeium"
                            end)
                            :filter(function(client)
                                return client.name ~= "Github Copilot"
                            end)
                            :map(function(client)
                                return client.name
                            end)
                            :totable()
                        local info = table.concat(clients, ", ")
                        return info
                    end
                },
                -- {
                --     function()
                --         return require('lsp-progress').progress()
                --     end
                -- }
                {
                    require("noice").api.status.search.get,
                    cond = require("noice").api.status.search.has
                },
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
                {
                    function()
                        local is_visual_mode = vim.fn.mode():find("[vVsS]")
                        if not is_visual_mode then
                            return ""
                        end
                        local starts = vim.fn.line("v")
                        local ends = vim.fn.line(".")
                        local lines = (starts <= ends and ends - starts + 1) or (starts - ends + 1)
                        return "󰫙 " .. tostring(lines) .. "," .. tostring(vim.fn.wordcount().visual_chars)
                    end
                },
                {
                    function()
                        local line = vim.fn.line('.')
                        local col = vim.fn.virtcol('.')
                        return string.format(' %3d,%-2d', line, col)
                    end
                }
            }
        }
    },
    config = function(_, opts)
        require("lualine").setup(opts)
        -- listen lsp-progress event and refresh lualine
        -- vim.api.nvim_create_augroup("lualine_augroup", { clear = true })
        -- vim.api.nvim_create_autocmd("User", {
        --     group = "lualine_augroup",
        --     pattern = "LspProgressStatusUpdated",
        --     callback = require("lualine").refresh,
        -- })
    end
}
