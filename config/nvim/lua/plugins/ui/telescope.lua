local color_util = require("brglng.color_util")

return {
    'nvim-telescope/telescope.nvim', branch = '0.1.x',
    cmd = "Telescope",
    dependencies = {
        'nvim-lua/plenary.nvim',
        'GustavoKatel/telescope-asynctasks.nvim'
    },
    config = function ()
        local actions = require("telescope.actions")
        require("telescope").setup {
            defaults = {
                sorting_strategy = "ascending",
                layout_config = {
                    prompt_position = "top",
                    height = 0.62,
                },
                borderchars = { " ", " ", " ", " ", " ", " ", " ", " " },
                prompt_prefix = "  ",
                selection_caret = "  ",
                mappings = {
                    i = {
                        ["<Esc>"] = actions.close,
                        ["<TAB>"] = { "<Esc>", type = "command" },
                    },
                    n = {
                        ["<Space>"] = actions.toggle_selection,
                    }
                }
            },
            pickers = {
                buffers = {
                    previewer = false,
                    layout_config = {
                        width = 0.62
                    },
                    mappings = {
                        i = {
                            ["<C-d>"] = actions.delete_buffer
                        },
                        n = {
                            ["d"] = actions.delete_buffer
                        }
                    }
                },
                current_buffer_fuzzy_find = {
                    previewer = false,
                    layout_config = {
                        width = 0.62,
                    },
                },
                help_tags = {
                    mappings = {
                        i = {
                            ["<CR>"] = actions.select_tab
                        },
                        n = {
                            ["<CR>"] = actions.select_tab
                        }
                    }
                },
                lsp_document_symbols = {
                    symbol_width = 50
                }
            },
            extensions = {
                asynctasks = {
                    layout_config = {
                        width = 0.62
                    }
                }
            }
        }

        local set_telescope_colors = function()
            local normal = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
            local normal_float = vim.api.nvim_get_hl(0, { name = "NormalFloat", link = false })
            if normal_float == nil then
                normal_float = vim.api.nvim_get_hl(0, { name = "Pmenu", link = false })
            end
            if normal_float.fg == nil then
                normal_float.fg = normal.fg
            end
            local pmenu_sel = vim.api.nvim_get_hl(0, { name = "PmenuSel", link = false })
            if pmenu_sel.fg == nil then
                pmenu_sel.fg = normal.fg
            end
            if pmenu_sel.reverse == true then
                pmenu_sel.fg, pmenu_sel.bg = pmenu_sel.bg, pmenu_sel.fg
            end
            -- vim.notify(string.format("normal_float = { fg = %s, bg = %s }", normal_float.fg, normal_float.bg))
            -- vim.notify(string.format("pmenu_sel = { fg = %s, bg = %s, reverse = %s }", pmenu_sel.fg, pmenu_sel.bg, pmenu_sel.reverse))
            local prompt_bg = color_util.transparency(pmenu_sel.bg, normal.bg, 0.3)
            local prompt_fg = normal_float.fg
            local prompt_counter_fg = color_util.transparency(prompt_fg, prompt_bg, 0.5)
            local preview_bg, preview_title_bg
            if vim.o.background == "light" then
                preview_bg = color_util.reduce_value(normal_float.bg, 0.05)
            else
                preview_bg = color_util.add_value(normal_float.bg, 0.05)
            end
            preview_title_bg = color_util.transparency(normal_float.fg, preview_bg, 0.6)
            vim.api.nvim_set_hl(0, "TelescopePromptNormal", {
                fg = prompt_fg,
                bg = prompt_bg
            })
            vim.api.nvim_set_hl(0, "TelescopePromptBorder", {
                fg = prompt_bg,
                bg = prompt_bg
            })
            vim.api.nvim_set_hl(0, "TelescopePromptTitle", {
                fg = pmenu_sel.fg,
                bg = pmenu_sel.bg
            })
            vim.api.nvim_set_hl(0, "TelescopePromptCounter", {
                fg = prompt_counter_fg
            })
            vim.api.nvim_set_hl(0, "TelescopeNormal", {
                fg = normal_float.fg,
                bg = normal_float.bg
            })
            vim.api.nvim_set_hl(0, "TelescopeBorder", {
                fg = normal_float.bg,
                bg = normal_float.bg
            })
            vim.api.nvim_set_hl(0, "TelescopeResultsTitle", {
                fg = normal_float.bg,
                bg = normal_float.bg
            })
            vim.api.nvim_set_hl(0, "TelescopeSelection", {
                fg = pmenu_sel.fg,
                bg = pmenu_sel.bg
            })
            vim.api.nvim_set_hl(0, "TelescopeMatching", { link = "Search" })
            vim.api.nvim_set_hl(0, "TelescopePreviewNormal", {
                bg = preview_bg
            })
            vim.api.nvim_set_hl(0, "TelescopePreviewBorder", {
                bg = preview_bg
            })
            vim.api.nvim_set_hl(0, "TelescopePreviewTitle", {
                fg = normal_float.bg,
                bg = preview_title_bg
            })
        end

        set_telescope_colors()

        vim.api.nvim_create_autocmd("ColorScheme", {
            pattern = "*",
            callback = set_telescope_colors,
        })
        vim.api.nvim_create_autocmd("OptionSet", {
            pattern = "background",
            callback = set_telescope_colors
        })
    end
}
