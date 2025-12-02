return {
    'nvim-telescope/telescope.nvim',
    version = "*",
    cond = true,
    lazy = false,
    dependencies = {
        'nvim-lua/plenary.nvim',
        { "nvim-telescope/telescope-ui-select.nvim", cond = true },
        "nvim-telescope/telescope-file-browser.nvim",
        'GustavoKatel/telescope-asynctasks.nvim',
        { 'nvim-telescope/telescope-fzf-native.nvim', build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release --target install' }
    },
    config = function()
        require('telescope').load_extension('asynctasks')
        require('telescope').load_extension('fzf')
        require("telescope").load_extension("ui-select")

        local actions = require("telescope.actions")

        require('telescope.pickers.layout_strategies').brglng_term = function(picker, columns, lines, layout_config)
            local config = require('telescope.pickers.layout_strategies').horizontal(picker, columns, lines, layout_config)
            config.prompt.width = config.results.width + 1
            config.results.height = config.results.height + 1
            config.results.width = config.results.width + 1
            config.results.line = config.results.line - 1
            return config
        end
        require('telescope.pickers.layout_strategies').brglng_term_nopreview = function(picker, columns, lines, layout_config)
            local config = require('telescope.pickers.layout_strategies').horizontal(picker, columns, lines, layout_config)
            config.results.height = config.results.height + 1
            config.results.line = config.results.line - 1
            return config
        end

        require("telescope").setup {
            defaults = {
                sorting_strategy = "ascending",
                -- layout_strategy = 'brglng',
                layout_strategy = (function()
                    if not vim.g.neovide then
                        return 'brglng_term'
                    end
                end)(),
                layout_config = {
                    prompt_position = "top",
                    width = 0.62,
                    height = 0.62,
                    preview_width = 0.5
                },
                border = (function()
                    if not vim.g.neovide then
                        return {
                            prompt = { 1, 1, 1, 1 },
                            results = { 1, 1, 1, 1 },
                            preview = { 1, 1, 1, 1 },
                        }
                    end
                end)(),
                borderchars = (function()
                    if not vim.g.neovide then
                        return {
                            prompt = { "─", "│", "─", "│", "╭", "─", "─", "├" },
                            results = { "─", "│", "─", "│", "├", "┤", "┴", "╰" },
                            preview = { "─", "│", "─", "│", "┬", "╮", "╯", "┴" },
                        }
                    end
                end)(),
                results_title = false,
                -- borderchars = { "", "", "", "", "", "", "", "" },
                -- borderchars = { " ", " ", " ", " ", " ", " ", " ", " " },
                -- borderchars = { '▔', '▕', '▁', '▏', '🭽', '🭾', '🭿', '🭼', },
                prompt_prefix = "   ",
                selection_caret = "  ",
                mappings = {
                    i = {
                        ["<Esc>"] = actions.close,
                        ["<TAB>"] = { "<Esc>", type = "command" },
                        -- ["<TAB>"] = actions.move_selection_next,
                        -- ["<S-TAB>"] = actions.move_selection_previous
                    },
                    n = {
                        ["<Space>"] = actions.toggle_selection,
                        -- ["<TAB>"] = actions.move_selection_next,
                        -- ["<S-TAB>"] = actions.move_selection_previous
                    }
                }
            },
            pickers = {
                buffers = {
                    previewer = false,
                    layout_strategy = (function()
                        if not vim.g.neovide then
                            return 'brglng_term_nopreview'
                        end
                    end)(),
                    borderchars = (function ()
                        if not vim.g.neovide then
                            return {
                                prompt = { "─", "│", "─", "│", "╭", "╮", "┤", "├" },
                                results = { "─", "│", "─", "│", "├", "┤", "╯", "╰" },
                            }
                        end
                    end)(),
                    ignore_current_buffer = true,
                    sort_mru = true,
                    layout_config = {
                        -- width = 0.62
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
                    layout_strategy = (function()
                        if not vim.g.neovide then
                            return 'brglng_term_nopreview'
                        end
                    end)(),
                    borderchars = (function ()
                        if not vim.g.neovide then
                            return {
                                prompt = { "─", "│", "─", "│", "╭", "╮", "┤", "├" },
                                results = { "─", "│", "─", "│", "├", "┤", "╯", "╰" },
                            }
                        end
                    end)(),
                    layout_config = {
                        -- width = 0.62,
                    },
                },
                find_files = {
                    previewer = false,
                    layout_strategy = (function()
                        if not vim.g.neovide then
                            return 'brglng_term_nopreview'
                        end
                    end)(),
                    borderchars = (function ()
                        if not vim.g.neovide then
                            return {
                                prompt = { "─", "│", "─", "│", "╭", "╮", "┤", "├" },
                                results = { "─", "│", "─", "│", "├", "┤", "╯", "╰" },
                            }
                        end
                    end)(),
                    layout_config = {
                        -- width = 0.62
                    },
                    -- hidden = true,
                    find_command = {
                        "fd",
                        "-H",
                        "-I",
                        "--exclude={.DS_Store,Thumbs.db,*.swp,*.swo,.clangd,.git,.idea,.vscode,.sass-cache,.mypy_cache,node_modules,build,.vscode-server,.virtualenvs,.venv*,.cache,.ghcup,.conda,.rustup,.cargo,target,.stfolder,.vs,*.pyc,*.egg-info,.pixi,.conan,.conan2}",
                        "--strip-cwd-prefix",
                        "--path-separator", "/"
                    },
                    -- find_command = {
                    --     "bfind",
                    --     "-H",
                    --     "-I",
                    --     ".DS_Store,Thumbs.db,*.swp,*.swo,.clangd,.git,.idea,.vscode,.sass-cache,.mypy_cache,node_modules,build,.vscode-server,.virtualenvs,.venv*,.cache,.ghcup,.conda,.rustup,.cargo,target,.stfolder,.vs,*.pyc,*.egg_info,.pixi,.conan,.conan2",
                    --     "--strip-cwd-prefix"
                    -- },
                },
                help_tags = {
                    mappings = {
                        i = {
                            ["<CR>"] = actions.select_vertical
                        },
                        n = {
                            ["<CR>"] = actions.select_vertical
                        }
                    }
                },
                live_grep = {
                    additional_args = function()
                        return {
                            "--path-separator", "/",
                            "--no-ignore",
                            "--glob=!.DS_Store",
                            "--glob=!Thumbs.db",
                            "--glob=!*.swp",
                            "--glob=!*.swo",
                            "--glob=!.clangd",
                            "--glob=!.git",
                            "--glob=!.idea",
                            "--glob=!.vscode",
                            "--glob=!.sass-cache",
                            "--glob=!.mypy_cache",
                            "--glob=!node_modules",
                            "--glob=!build",
                            "--glob=!.vscode-server",
                            "--glob=!.virtualenvs",
                            "--glob=!.venv*",
                            "--glob=!.cache",
                            "--glob=!.ghcup",
                            "--glob=!.conda",
                            "--glob=!.rustup",
                            "--glob=!.cargo",
                            "--glob=!target",
                            "--glob=!.stfolder",
                            "--glob=!.vs",
                            "--glob=!*.pyc",
                            "--glob=!*.egg-info",
                            "--glob=!.pixi",
                            "--glob=!.conan",
                            "--glob=!.conan2",
                    }
                    end
                },
                lsp_document_symbols = {
                    previewer = false,
                    layout_strategy = (function()
                        if not vim.g.neovide then
                            return 'brglng_term_nopreview'
                        end
                    end)(),
                    borderchars = (function ()
                        if not vim.g.neovide then
                            return {
                                prompt = { "─", "│", "─", "│", "╭", "╮", "┤", "├" },
                                results = { "─", "│", "─", "│", "├", "┤", "╯", "╰" },
                            }
                        end
                    end)(),
                    symbol_width = 0.8
                },
                oldfiles = {
                    previewer = false,
                    layout_strategy = (function()
                        if not vim.g.neovide then
                            return 'brglng_term_nopreview'
                        end
                    end)(),
                    borderchars = (function ()
                        if not vim.g.neovide then
                            return {
                                prompt = { "─", "│", "─", "│", "╭", "╮", "┤", "├" },
                                results = { "─", "│", "─", "│", "├", "┤", "╯", "╰" },
                            }
                        end
                    end)(),
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
                        width = 0.3,
                        height = 0.3,
                    }
                },
                file_browser = {
                    previewer = false,
                    layout_strategy = (function()
                        if not vim.g.neovide then
                            return 'brglng_term_nopreview'
                        end
                    end)(),
                    borderchars = (function ()
                        if not vim.g.neovide then
                            return {
                                prompt = { "─", "│", "─", "│", "╭", "╮", "┤", "├" },
                                results = { "─", "│", "─", "│", "├", "┤", "╯", "╰" },
                            }
                        end
                    end)(),
                    hijack_netrw = false
                },
                ["ui-select"] = {
                    layout_strategy = (function()
                        if not vim.g.neovide then
                            return 'brglng_term_nopreview'
                        end
                    end)(),
                    borderchars = (function ()
                        if not vim.g.neovide then
                            return {
                                prompt = { "─", "│", "─", "│", "╭", "╮", "┤", "├" },
                                results = { "─", "│", "─", "│", "├", "┤", "╯", "╰" },
                            }
                        end
                    end)(),
                    layout_config = {
                        width = 0.5,
                        height = 0.5
                    }
                },
            }
        }

        local brglng = require("brglng")
        if vim.g.neovide then
            brglng.hl.transform_tbl {
                TelescopePromptTitle = { fg = "Normal.bg", bg = "FloatTitle.fg" },
                TelescopePreviewTitle = { fg = "Normal.bg", bg = "FloatTitle.fg" },
                TelescopeSelection = { fg = "PmenuSel.fg", bg = "PmenuSel.bg" },
                TelescopeMatching = { link = "Search" },
                TelescopePromptNormal = {
                    fg = "NormalFloat.fg,Normal.fg",
                    bg = { transform = "deboss", from = "NormalFloat.bg,Normal.bg", amount = 0.2 }
                },
                TelescopePromptBorder = {
                    fg = { transform = "deboss", from = "NormalFloat.bg,Normal.bg", amount = 0.2 },
                    bg = { transform = "deboss", from = "NormalFloat.bg,Normal.bg", amount = 0.2 }
                },
                TelescopeNormal = { fg = "NormalFloat.fg,Normal.fg", bg = "NormalFloat.bg,Normal.bg" },
                TelescopeResultsBorder = { fg = "NormalFloat.bg,Normal.bg", bg = "NormalFloat.bg,Normal.bg" },
                TelescopePreviewNormal = {
                    fg = "NormalFloat.fg,Normal.fg",
                    bg = { transform = "emboss", from = "NormalFloat.bg,Normal.bg", amount = 0.03 }
                },
                TelescopePreviewBorder = {
                    fg = { transform = "emboss", from = "NormalFloat.bg,Normal.bg", amount = 0.03 },
                    bg = { transform = "emboss", from = "NormalFloat.bg,Normal.bg", amount = 0.03 }
                },
            }
        else
            brglng.hl.transform_tbl {
                TelescopePromptTitle = { fg = "Normal.bg", bg = "FloatTitle.fg" },
                TelescopePreviewTitle = { fg = "Normal.bg", bg = "FloatTitle.fg" },
                TelescopeSelection = { fg = "PmenuSel.fg", bg = "PmenuSel.bg" },
                TelescopeMatching = { link = "Search" },
                TelescopePromptNormal = { fg = "NormalFloat.fg,Normal.fg", bg = nil },
                TelescopePromptBorder = { fg = "FloatBorder.fg", bg = nil },
                TelescopeNormal = { fg = "NormalFloat.fg,Normal.fg", bg = nil },
                TelescopeResultsBorder = { fg = "FloatBorder.fg", bg = nil, },
                TelescopePreviewNormal = { fg = "NormalFloat.fg,Normal.fg", bg = nil, },
                TelescopePreviewBorder = { fg = "FloatBorder.fg", bg = nil }
            }
        end
    end,
    keys = {
        { '<Leader>b', mode = 'n', function() require('telescope.builtin').buffers() end, desc = 'Buffers' },
        { '<Leader>fb', mode = 'n', function() require('telescope.builtin').buffers() end, desc = 'Buffers' },
        { '<Leader>f;', mode = 'n', function() require('telescope.builtin').commands() end, desc = 'Commands' },
        { '<Leader>fc', mode = 'n', function() require('telescope.builtin').colorscheme() end, desc = 'Color Schemes' },
        { '<Leader>fd', mode = 'n', function() require('telescope').extensions.file_browser.file_browser() end, desc = 'Browser' },
        { '<Leader>ff', mode = 'n', function() require('telescope.builtin').find_files() end, desc = 'Files' },
        { '<Leader>fg', mode = 'n', function() require('telescope.builtin').live_grep() end, desc = 'Grep' },
        { '<Leader>fh', mode = 'n', function() require('telescope.builtin').help_tags() end, desc = 'Help Tags' },
        { '<Leader>fl', mode = 'n', function() require('telescope.builtin').current_buffer_fuzzy_find() end, desc = 'Lines' },
        { "<Leader>f'", mode = 'n', function() require('telescope.builtin').marks() end, desc = 'Marks' },
        { '<Leader>fm', mode = 'n', function() require('telescope.builtin').man_pages() end, desc = 'Man Pages' },
        { '<Leader>fo', mode = 'n', function() require('telescope.builtin').vim_options() end, desc = 'Vim Options' },
        { '<Leader>fs', mode = 'n', function() require('telescope.builtin').lsp_document_symbols() end, desc = 'LSP Document Symbols' },
        { '<Leader>fr', mode = 'n', function() require('telescope.builtin').resume() end, desc = 'Resume Previous Picker' },
        { "<Leader>t", mode = "n",  function() require("telescope").extensions.asynctasks.all() end, desc = "Tasks" },
    }
}
