return {
    "goolord/alpha-nvim",
    enabled = true,
    event = "VimEnter",
    -- lazy = false,
    dependencies = {
        "echasnovski/mini.icons",
        "nvim-lua/plenary.nvim"
    },
    config = function()
        local fortune = require("alpha.fortune")()

        local if_nil = vim.F.if_nil
        local fnamemodify = vim.fn.fnamemodify
        local filereadable = vim.fn.filereadable

        -- helper function for utf8 chars
        local function utf8_len(s, pos)
            local byte = string.byte(s, pos)
            if not byte then
                return nil
            end
            return (byte < 0x80 and 1) or (byte < 0xE0 and 2) or (byte < 0xF0 and 3) or (byte < 0xF8 and 4) or 1
        end

        local function apply_colors(logo, colors, logoColors)
            local result = {
                type = "text",
                val = logo,
                opts = {
                    position = "center",
                }
            }

            for key, color in pairs(colors) do
                local name = "Alpha" .. key
                vim.api.nvim_set_hl(0, name, color)
                colors[key] = name
            end

            result.opts.hl = {}
            for i, line in ipairs(logoColors) do
                local highlights = {}
                local pos = 0

                for j = 1, #line do
                    local opos = pos
                    pos = pos + utf8_len(logo[i], opos + 1)

                    local color_name = colors[line:sub(j, j)]
                    if color_name then
                        table.insert(highlights, { color_name, opos, pos })
                    end
                end

                table.insert(result.opts.hl, highlights)
            end
            return { result }
        end

        --- @param sc string
        --- @param txt string
        --- @param fn string
        --- @param keybind string? optional
        --- @param keybind_opts table? optional
        local function button(sc, txt, fn, keybind, keybind_opts)
            local opts = {
                position = "center",
                shortcut = sc,
                cursor = 3,
                width = math.min(vim.fn.winwidth(0) - 2, 150),
                align_shortcut = "right",
                hl_shortcut = { { "Number", 0, 1 } },
                shrink_margin = false,
            }
            if keybind then
                keybind_opts = if_nil(keybind_opts, { noremap = true, silent = true, nowait = true })
                opts.keymap = { "n", sc, keybind, keybind_opts }
            end

            local function on_press()
                local key = vim.api.nvim_replace_termcodes(keybind .. "<Ignore>", true, false, true)
                vim.api.nvim_feedkeys(key, "n", false)
            end

            return {
                type = "button",
                val = txt,
                on_press = function()
                    vim.cmd('edit ' .. vim.fn.fnameescape(fn))
                end,
                opts = opts,
            }
        end

        local file_icons = {
            enabled = true,
            highlight = true,
            -- available: devicons, mini, to use nvim-web-devicons or mini.icons
            -- if provider not loaded and enabled is true, it will try to use another provider
            provider = "mini",
        }

        local function icon(fn)
            if file_icons.provider ~= "devicons" and file_icons.provider ~= "mini" then
                vim.notify("Alpha: Invalid file icons provider: " .. file_icons.provider .. ", disable file icons", vim.log.levels.WARN)
                file_icons.enabled = false
                return "", ""
            end

            local ico, hl = require("alpha.utils").get_file_icon(file_icons.provider, fn)
            if ico == "" then
                file_icons.enabled = false
                vim.notify("Alpha: Mini icons or devicons get icon failed, disable file icons", vim.log.levels.WARN)
            end
            return ico, hl
        end

        local function file_button(fn, sc, short_fn, autocd)
            short_fn = if_nil(short_fn, fn)
            local ico_txt
            local fb_hl = {}
            if file_icons.enabled then
                local ico, hl = icon(fn)
                local hl_option_type = type(file_icons.highlight)
                if hl_option_type == "boolean" then
                    if hl and file_icons.highlight then
                        table.insert(fb_hl, { hl, 0, #ico })
                    end
                end
                if hl_option_type == "string" then
                    table.insert(fb_hl, { file_icons.highlight, 0, #ico })
                end
                ico_txt = ico .. "  "
            else
                ico_txt = ""
            end
            local cd_cmd = (autocd and " | cd %:p:h" or "")
            local file_button_el = button(sc, ico_txt .. short_fn, fn, "<cmd>e " .. vim.fn.fnameescape(fn) .. cd_cmd .. " <CR>")
            local fn_start = short_fn:match(".*[/\\]")
            if fn_start ~= nil then
                table.insert(fb_hl, { "Comment", #ico_txt, #fn_start + #ico_txt })
            end
            file_button_el.opts.hl = fb_hl
            return file_button_el
        end

        local projects_load_state = 0
        local project_list = {}
        local projects_tbl = {
            {
                type = "text",
                val = "(Loading projects...)",
                opts = {
                    position = "center",
                    hl = "Comment",
                    width = math.min(vim.fn.winwidth(0) - 2, 150),
                }
            }
        }
        local function projects()
            local keys = {
                "1", "2", "3", "4", "5", "6", "7", "8", "9", "0"
            }
            local next_key_idx = 1
            local function next_key()
                local k = keys[next_key_idx]
                next_key_idx = next_key_idx + 1
                return k
            end
            if projects_load_state == 0 then
                -- vim.schedule(function ()
                    projects_load_state = 1
                    local path = require("neovim-project.utils.path")
                    local history = require("neovim-project.utils.history")
                    project_list = history.get_recent_projects()
                    -- Reverse results
                    for i = 1, math.floor(#project_list / 2) do
                        project_list[i], project_list[#project_list - i + 1] = project_list[#project_list - i + 1], project_list[i]
                    end
                    project_list = vim.list_slice(project_list, 1, math.min(10, #project_list))
                    project_list = path.fix_symlinks_for_history(project_list)
                    projects_load_state = 2
                --     vim.schedule(function () require("alpha").redraw() end)
                -- end)
            end
            -- elseif projects_load_state == 2 then
                local project = require("neovim-project.project")
                projects_tbl = {}
                for _, proj in ipairs(project_list) do
                    local short_proj
                    if vim.fn.strdisplaywidth(proj) > math.min(vim.fn.winwidth(0) - 2, 150) - 5 then
                        short_proj = "  ..." .. string.sub(proj, #proj - (math.min(vim.fn.winwidth(0) - 2, 150) - 8) + 1, #proj)
                    else
                        short_proj = "  " .. proj
                    end
                    local sc = next_key()
                    table.insert(projects_tbl, {
                        type = "button",
                        val = short_proj,
                        on_press = function() project.switch_project(proj) end,
                        opts = {
                            keymap = { "n", sc, function() project.switch_project(proj) end },
                            position = "center",
                            shortcut = sc,
                            align_shortcut = "right",
                            hl = { { "Directory", 0, 1 }, { "Normal", 1, -1 } },
                            hl_shortcut = "Number",
                            cursor = 3,
                            width = math.min(vim.fn.winwidth(0) - 2, 150),
                        }
                    })
                end
            -- end
            return projects_tbl
        end

        local default_mru_ignore = { "gitcommit" }

        local mru_opts = {
            ignore = function(path, ext)
                return (string.find(path, "COMMIT_EDITMSG")) or (vim.tbl_contains(default_mru_ignore, ext))
            end,
            autocd = false
        }

        --- @param next_key function
        --- @param cwd string? optional
        --- @param items_number number? optional number of items to generate, default = 10
        local function mru(next_key, cwd, items_number, opts)
            opts = opts or mru_opts
            items_number = if_nil(items_number, 10)
            local oldfiles = {}
            for _, v in pairs(vim.v.oldfiles) do
                if #oldfiles == items_number then
                    break
                end
                local cwd_cond
                if not cwd then
                    cwd_cond = true
                else
                    cwd_cond = vim.startswith(v, cwd)
                end
                local ignore = (opts.ignore and opts.ignore(v, require("alpha.utils").get_extension(v))) or false
                if (filereadable(v) == 1) and cwd_cond and not ignore then
                    oldfiles[#oldfiles + 1] = v
                end
            end

            local tbl = {}
            for i, fn in ipairs(oldfiles) do
                local short_fn
                if cwd then
                    short_fn = fnamemodify(fn, ":.")
                else
                    short_fn = fn
                end
                if vim.fn.isabsolutepath(short_fn) then
                    short_fn = fnamemodify(short_fn, ":~")
                end
                -- vim.notify(tostring(vim.fn.winwidth(0)))
                if vim.fn.strdisplaywidth(short_fn) > math.min(vim.fn.winwidth(0) - 2, 150) - 5 then
                    short_fn = "..." .. string.sub(short_fn, #short_fn - (math.min(vim.fn.winwidth(0) - 2, 150) - 8) + 1, #short_fn)
                end
                local file_button_el = file_button(fn, next_key(), short_fn, opts.autocd)
                tbl[i] = file_button_el
            end
            return tbl
        end

        local function projects_and_mru()
            local keys = {
                "a", "b", "c", "d", "e", "f", "g", "h", "i", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"
            }
            local next_key_idx = 1
            local function next_key()
                local k = keys[next_key_idx]
                next_key_idx = next_key_idx + 1
                return k
            end
            return {
                { type = "text", val = "Recent Projects", opts = { hl = "Title" } },
                { type = "padding", val = 1 },
                {
                    type = "group",
                    val = function()
                        return projects()
                    end
                },
                { type = "padding", val = 1 },
                {
                    type = "text",
                    val = function()
                        return {
                            "Recent Files in " .. vim.fn.getcwd()
                        }
                    end,
                    opts = {
                        hl = "Title",
                    }
                },
                { type = "padding", val = 1 },
                {
                    type = "group",
                    val = function()
                        return mru(next_key, vim.fn.getcwd(), 10)
                    end
                },
                { type = "padding", val = 1 },
                {
                    type = "text",
                    val = "All Recent Files",
                    opts = {
                        hl = "Title"
                    }
                },
                { type = "padding", val = 1 },
                {
                    type = "group",
                    val = function()
                        return mru(next_key, nil, 10)
                    end
                },
            }
        end

        require("alpha").setup {
            layout = {
                { type = "padding", val = 1 },
                -- {
                --     type = "text",
                --     val = {
                --         "",
                --         "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
                --         "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
                --         "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
                --         "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
                --         "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
                --         "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
                --     },
                --     opts = {
                --         position = "center"
                --     }
                -- },
                {
                    type = "group",
                    val = function()
                        return apply_colors({
                            [[  ███       ███  ]],
                            [[  ████      ████ ]],
                            [[  ████     █████ ]],
                            [[ █ ████    █████ ]],
                            [[ ██ ████   █████ ]],
                            [[ ███ ████  █████ ]],
                            [[ ████ ████ ████ ]],
                            [[ █████  ████████ ]],
                            [[ █████   ███████ ]],
                            [[ █████    ██████ ]],
                            [[ █████     █████ ]],
                            [[ ████      ████ ]],
                            [[  ███       ███  ]],
                            -- [[                    ]],
                            -- [[  N  E  O  V  I  M  ]],
                        }, {
                            ["b"] = { fg = "#3399ff", ctermfg = 33 },
                            ["a"] = { fg = "#53C670", ctermfg = 35 },
                            ["g"] = { fg = "#39ac56", ctermfg = 29 },
                            ["h"] = { fg = "#33994d", ctermfg = 23},
                            ["i"] = { fg = "#33994d", bg = "#39ac56", ctermfg = 23, ctermbg = 29},
                            ["j"] = { fg = "#53C670", bg = "#33994d", ctermfg = 35, ctermbg = 23 },
                            ["k"] = { fg = "#30A572", ctermfg = 36},
                        }, {
                            [[  kkkka       gggg  ]],
                            [[  kkkkaa      ggggg ]],
                            [[ b kkkaaa     ggggg ]],
                            [[ bb kkaaaa    ggggg ]],
                            [[ bbb kaaaaa   ggggg ]],
                            [[ bbbb aaaaaa  ggggg ]],
                            [[ bbbbb aaaaaa igggg ]],
                            [[ bbbbb  aaaaaahiggg ]],
                            [[ bbbbb   aaaaajhigg ]],
                            [[ bbbbb    aaaaajhig ]],
                            [[ bbbbb     aaaaajhi ]],
                            [[ bbbbb      aaaaajh ]],
                            [[  bbbb       aaaaa  ]],
                            -- [[                    ]],
                            -- [[  a  a  a  b  b  b  ]],
                        })
                    end
                },
                {
                    type = "text",
                    val = function()
                        local lazy = require("lazy")
                        local stats = lazy.stats()
                        return {
                            "",
                            "Startuptime: " .. stats.startuptime .. " ms",
                            "Plugins: " .. stats.loaded .. " loaded / " .. stats.count .. " installed",
                        }
                    end,
                    opts = {
                        position = "center",
                        hl = "Comment"
                    }
                },
                {
                    type = "text",
                    val = fortune,
                    opts = {
                        position = "center",
                        hl = "DiagnosticHint"
                    }
                },
                { type = "padding", val = 1 },
                {
                    type = "group",
                    val = {
                        {
                            type = "button",
                            val = "  New File",
                            on_press = function()
                                vim.cmd("enew")
                            end,
                            opts = {
                                shortcut = "N",
                                keymap = { "n", "N", "<Cmd>enew<CR>", { noremap = true, silent = true, nowait = true } },
                            }
                        },
                        {
                            type = "button",
                            val = "  Find Files",
                            on_press = function()
                                require("telescope.builtin").find_files()
                            end,
                            opts = {
                                shortcut = "F",
                                keymap  = { "n", "F", function() require("telescope.builtin").find_files() end, { noremap = true, silent = true, nowait = true } },
                            }
                        },
                        {
                            type = "button",
                            val = "  Browse",
                            on_press = function()
                                require("telescope").extensions.file_browser.file_browser()
                            end,
                            opts = {
                                shortcut = "B",
                                keymap = { "n", "B", function() require("telescope").extensions.file_browser.file_browser() end, { noremap = true, silent = true, nowait = true  } },
                            }
                        },
                        {
                            type = "button",
                            val = "  Projects",
                            on_press = function()
                                vim.cmd("NeovimProjectDiscover")
                            end,
                            opts = {
                                shortcut = "P",
                                keymap = { "n", "P", "<Cmd>NeovimProjectDiscover<CR>", { noremap = true, silent = true, nowait = true  } },
                            }
                        },
                        {
                            type = "button",
                            val = "  Update Plugins",
                            on_press = function()
                                require("lazy").update()
                            end,
                            opts = {
                                shortcut = "U",
                                keymap = { "n", "U", "<Cmd>Lazy update<CR>", { noremap = true, silent = true, nowait = true } },
                            }
                        },
                        {
                            type = "button",
                            -- val = "  Plugin Profile",
                            val = "  Plugin Profile",
                            -- val = "  Plugin Profile",
                            on_press = function()
                                require("lazy").profile()
                            end,
                            opts = {
                                shortcut = "T",
                                keymap = { "n", "T", "<Cmd>Lazy profile<CR>", { noremap = true, silent = true, nowait = true } },
                            }
                        },
                        {
                            type = "button",
                            val = "  Quit",
                            on_press = function()
                                vim.cmd("qa")
                            end,
                            opts = {
                                shortcut = "Q",
                                keymap = { "n", "Q", "<Cmd>qa<CR>", { noremap = true, silent = true, nowait = true } },
                            }
                        }
                    },
                    opts = {
                        spacing = 1,
                        inherit = {
                            position = "center",
                            align_shortcut = "right",
                            width = 50,
                            hl = { { "Tag", 0, 1 }, { "Normal", 1, -1 } },
                            hl_shortcut = "Number",
                            cursor = 3,
                        }
                    }
                },
                { type = "group", val = projects_and_mru, opts = { inherit = { position = "center" } } },
                { type = "padding", val = 1 },
            },
            opts = {
                -- noautocmd = true
            }
        }

        vim.api.nvim_create_autocmd("User", {
            once = true,
            pattern = "LazyVimStarted",
            callback = function()
                require("alpha").redraw()
                -- vim.cmd [[ AlphaRedraw ]]
            end
        })

        vim.cmd [[ autocmd User AlphaReady set showtabline=0 | autocmd BufUnload <buffer> set showtabline=2 ]]
    end
}
