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
            section_separators = { left = '', right = '' },
            component_separators = { left = '', right = '' },
            -- component_separators = "|",
        },
        -- extensions = {
        --     "lazy",
        --     "neo-tree",
        --     "quickfix",
        --     "trouble"
        -- },
        sections = {
            lualine_a =  {
                {
                    "mode",
                    separator = { left = '', right = "" },
                    right_padding = 2
                }
            },
            lualine_b = {
                {
                    function()
                        -- return " " .. vim.uv.cwd():gsub(vim.env.HOME, "~")
                        return " " .. vim.fs.basename(vim.uv.cwd())
                    end
                },
                "branch",
                "diff",
                {
                    "diagnostics",
                    sources = { "nvim_diagnostic", "nvim_lsp" },
                    sections = { "error", "warn", "info", "hint" },
                    -- symbols = { error = " ", warn = " ", info = " ", hint = "󰌶 " },
                    symbols = { error = " ", warn = " ", info = " ", hint = "󰌵 " },
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
                -- {
                --     require("noice").api.status.search.get,
                --     cond = require("noice").api.status.search.has
                -- },
            },
            lualine_x = {
                {
                    require("noice").api.status.command.get,
                    cond = require("noice").api.status.command.has,
                },
                'encoding',
                {
                    function()
                        return "sw=" .. vim.o.shiftwidth .. " ts=" .. vim.o.tabstop .. " sts=" .. vim.o.softtabstop .. " et=" .. (vim.o.expandtab and "on" or "off")
                    end
                },
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
                        return string.format(' %d  %d', line, col)
                    end,
                    separator = { left = '', right = '' },
                    left_padding = 2
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
