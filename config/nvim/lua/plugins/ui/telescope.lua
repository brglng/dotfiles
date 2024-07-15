return {
    'nvim-telescope/telescope.nvim', branch = '0.1.x',
    cmd = "Telescope",
    dependencies = {
        'nvim-lua/plenary.nvim',
        'GustavoKatel/telescope-asynctasks.nvim',
        { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' }
    },
    config = function()
        local actions = require("telescope.actions")
        require('telescope').load_extension('asynctasks')
        require('telescope').load_extension('fzf')

        require("telescope").setup {
            defaults = {
                sorting_strategy = "ascending",
                layout_config = {
                    prompt_position = "top",
                    height = 0.62,
                },
                -- borderchars = { " ", " ", " ", " ", " ", " ", " ", " " },
                -- borderchars = { '▔', '▕', '▁', '▏', '🭽', '🭾', '🭿', '🭼', },
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
                    ignore_current_buffer = true,
                    sort_mru = true,
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
                    },
                },
                current_buffer_fuzzy_find = {
                    previewer = false,
                    layout_config = {
                        width = 0.62,
                    },
                },
                find_files = {
                    -- hidden = true,
                    find_command = {
                        "fd",
                        "-H",
                        "-I",
                        "--exclude={.git,.idea,.vscode,.sass-cache,node_modules,build,.vscode-server,.virtualenvs,.cache,.ghcup,.conda,.rustup,.cargo,.local}",
                        "--strip-cwd-prefix",
                    },
                    -- theme = 'ivy'
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
                },
                oldfiles = {
                    hidden = true,
                },
            },
            extensions = {
                fzf = {
                    fuzzy = true,
                    override_generic_sorter = true,
                    override_file_sorter = true,
                    case_mode = 'smart_case',
                },
                asynctasks = {
                    layout_config = {
                        width = 0.62
                    }
                }
            }
        }

        local colorutil = require("brglng.colorutil")
        local set_telescope_colors = function()
            local Normal = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
            local NormalFloat = vim.api.nvim_get_hl(0, { name = "NormalFloat", link = false })
            if NormalFloat == nil then
                NormalFloat = vim.api.nvim_get_hl(0, { name = "Pmenu", link = false })
            end
            if NormalFloat.fg == nil then
                NormalFloat.fg = Normal.fg
            end
            local PmenuSel = vim.api.nvim_get_hl(0, { name = "PmenuSel", link = false })
            if PmenuSel.fg == nil then
                PmenuSel.fg = Normal.fg
            end
            if PmenuSel.reverse == true then
                PmenuSel.fg, PmenuSel.bg = PmenuSel.bg, PmenuSel.fg
            end
            -- vim.notify(string.format("NormalFloat = { fg = %s, bg = %s }", NormalFloat.fg, NormalFloat.bg))
            -- vim.notify(string.format("PmenuSel = { fg = %s, bg = %s, reverse = %s }", PmenuSel.fg, PmenuSel.bg, PmenuSel.reverse))
            -- local prompt_bg = colorutil.transparency(PmenuSel.bg, Normal.bg, 0.3)
            local prompt_bg
            if vim.o.background == 'dark' then
                prompt_bg = colorutil.reduce_value(NormalFloat.bg, 0.07)
            else
                prompt_bg = colorutil.add_value(NormalFloat.bg, 0.05)
            end
            local prompt_fg = NormalFloat.fg
            local prompt_counter_fg = colorutil.transparency(prompt_fg, prompt_bg, 0.5)
            local preview_bg, preview_title_bg
            if vim.o.background == "light" then
                preview_bg = colorutil.reduce_value(NormalFloat.bg, 0.03)
            else
                preview_bg = colorutil.add_value(NormalFloat.bg, 0.05)
            end
            preview_title_bg = colorutil.transparency(NormalFloat.fg, preview_bg, 0.6)
            vim.api.nvim_set_hl(0, "TelescopePromptNormal", {
                fg = prompt_fg,
                bg = prompt_bg
            })
            vim.api.nvim_set_hl(0, "TelescopePromptBorder", {
                fg = prompt_bg,
                bg = prompt_bg
            })
            if vim.o.background == 'dark' then
                vim.api.nvim_set_hl(0, "TelescopePromptTitle", {
                    fg = prompt_bg,
                    bg = colorutil.add_value(prompt_bg, 0.5)
                })
            else
                vim.api.nvim_set_hl(0, "TelescopePromptTitle", {
                    fg = prompt_bg,
                    bg = colorutil.add_saturation(colorutil.reduce_value(prompt_bg, 0.4), 0.2)
                })
            end
            vim.api.nvim_set_hl(0, "TelescopePromptCounter", {
                fg = prompt_counter_fg
            })
            vim.api.nvim_set_hl(0, "TelescopeNormal", {
                fg = NormalFloat.fg,
                bg = NormalFloat.bg
            })
            vim.api.nvim_set_hl(0, "TelescopeBorder", {
                fg = NormalFloat.bg,
                bg = NormalFloat.bg
            })
            vim.api.nvim_set_hl(0, "TelescopeResultsTitle", {
                fg = NormalFloat.bg,
                bg = NormalFloat.bg
            })
            vim.api.nvim_set_hl(0, "TelescopeSelection", {
                fg = PmenuSel.fg,
                bg = PmenuSel.bg
            })
            vim.api.nvim_set_hl(0, "TelescopeMatching", { link = "Search" })
            vim.api.nvim_set_hl(0, "TelescopePreviewNormal", {
                bg = preview_bg
            })
            vim.api.nvim_set_hl(0, "TelescopePreviewBorder", {
                fg = preview_bg,
                bg = preview_bg
            })
            vim.api.nvim_set_hl(0, "TelescopePreviewTitle", {
                fg = NormalFloat.bg,
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
    end,
    keys = {
        { '<Leader>b', mode = 'n', require('telescope.builtin').buffers, desc = 'Buffers' },
        { '<Leader>fb', mode = 'n', require('telescope.builtin').buffers, desc = 'Buffers' },
        { '<Leader>fc', mode = 'n', require('telescope.builtin').command, desc = 'Commands' },
        { '<Leader>fC', mode = 'n', require('telescope.builtin').colorscheme, desc = 'Color Schemes' },
        { '<Leader>ff', mode = 'n', require('telescope.builtin').find_files, desc = 'Files' },
        { '<Leader>fg', mode = 'n', require('telescope.builtin').live_grep, desc = 'Grep' },
        { '<Leader>fh', mode = 'n', require('telescope.builtin').help_tags, desc = 'Help Tags' },
        { '<Leader>fl', mode = 'n', require('telescope.builtin').current_buffer_fuzzy_find, desc = 'Lines' },
        { '<Leader>fm', mode = 'n', require('telescope.builtin').marks, desc = 'Marks' },
        { '<Leader>fM', mode = 'n', require('telescope.builtin').man_pagkes, desc = 'Man Pages' },
        { '<Leader>fo', mode = 'n', require('telescope.builtin').vim_options, desc = 'Vim Options' },
        { '<Leader>fs', mode = 'n', require('telescope.builtin').lsp_document_symbols, desc = 'LSP Document Symbols' },
        { '<Leader>fr', mode = 'n', require('telescope.builtin').resume, desc = 'Resume Previous Picker' },
    }
}
