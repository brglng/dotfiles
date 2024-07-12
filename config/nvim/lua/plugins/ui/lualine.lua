return {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    lazy = true,
    dependencies = {
        "nvim-tree/nvim-web-devicons",
        -- "SmiteshP/nvim-navic",
        -- "linrongbin16/lsp-progress.nvim",
        "folke/noice.nvim"
    },
    opts = {
        options = {
            globalstatus = true,
            -- section_separators = { left = '', right = '' },
            -- component_separators = { left = '', right = '' }
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
                }
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
    config = function (_, opts)
        require("lualine").setup(opts)
    end
}
