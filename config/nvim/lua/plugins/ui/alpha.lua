return {
    "goolord/alpha-nvim",
    enabled = true,
    event = "VimEnter",
    dependencies = {
        "coffebar/neovim-project",
        "nvim-tree/nvim-web-devicons",
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
                width = math.min(vim.fn.winwidth(0), 160) - 18,
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
                vim.api.nvim_feedkeys(key, "t", false)
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

        --- @param next_key function
        local function projects(next_key)
            local path = require("neovim-project.utils.path")
            local history = require("neovim-project.utils.history")
            local project = require("neovim-project.project")
            local results = history.get_recent_projects()
            results = path.fix_symlinks_for_history(results)
            -- Reverse results
            for i = 1, math.floor(#results / 2) do
                results[i], results[#results - i + 1] = results[#results - i + 1], results[i]
            end
            local tbl = {}
            for _, proj in ipairs(results) do
                local short_proj
                if utf8_len(proj) > math.min(vim.fn.winwidth(0), 160) - 24 then
                    short_proj = "  …" .. string.sub(proj, #proj - math.min(vim.fn.winwidth(0), 160) - 23, #proj)
                else
                    short_proj = "  " .. proj
                end
                local sc = next_key()
                table.insert(tbl, {
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
                        width = math.min(vim.fn.winwidth(0), 160) - 18,
                    }
                })
            end
            return tbl
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
                    short_fn = fnamemodify(fn, ":~")
                end
                -- vim.notify(tostring(vim.fn.winwidth(0)))
                if utf8_len(short_fn) > math.min(vim.fn.winwidth(0), 160) - 24 then
                    short_fn = "…" .. string.sub(short_fn, #short_fn - math.min(vim.fn.winwidth(0), 160) - 23, #short_fn)
                end
                local file_button_el = file_button(fn, next_key(), short_fn, opts.autocd)
                tbl[i] = file_button_el
            end
            return tbl
        end

        local function projects_and_mru()
            local keys = {
                "a", "c", "d", "h", "i", "l", "m", "n", "o", "r", "s", "v", "w", "x", "y", "z",
                "1", "2", "3", "4", "5", "6", "7", "8", "9", "0",
                ";", "'", "[", "]", "<", ">", "/", "\\", "-", "=",
                "A", "B", "C", "D", "E", "F", "H", "I", "J", "K", "L", "M", "N", "O", "P", "R", "S", "T", "U", "V", "W", "X", "Y", "Z",
            }
            local next_key_idx = 1
            local function next_key()
                local k = keys[next_key_idx]
                next_key_idx = next_key_idx + 1
                return k
            end
            return {
                { type = "text", val = "Recent Projects", opts = { hl = "Title" } },
                {
                    type = "group",
                    val = function()
                        return projects(next_key)
                    end
                },
                { type = "padding", val = 2 },
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
                { type = "padding", val = 2 },
                {
                    type = "text",
                    val = "Recent Files in All",
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
                            "",
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
                        hl = "String"
                    }
                },
                { type = "padding", val = 2 },
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
                                shortcut = "e",
                                keymap = { "n", "e", "<Cmd>enew<CR>", { noremap = true, silent = true, nowait = true } },
                            }
                        },
                        {
                            type = "button",
                            val = "  Find Files",
                            on_press = function()
                                require("telescope.builtin").find_files()
                            end,
                            opts = {
                                shortcut = "f",
                                keymap  = { "n", "f", function() require("telescope.builtin").find_files() end, { noremap = true, silent = true, nowait = true } },
                            }
                        },
                        {
                            type = "button",
                            val = "  Browse",
                            on_press = function()
                                require("telescope").extensions.file_browser.file_browser()
                            end,
                            opts = {
                                shortcut = "b",
                                keymap = { "n", "b", function() require("telescope").extensions.file_browser.file_browser() end, { noremap = true, silent = true, nowait = true  } },
                            }
                        },
                        {
                            type = "button",
                            val = "  Update Plugins",
                            on_press = function()
                                require("lazy").update()
                            end,
                            opts = {
                                shortcut = "u",
                                keymap = { "n", "u", "<Cmd>Lazy update<CR>", { noremap = true, silent = true, nowait = true } },
                            }
                        },
                        {
                            type = "button",
                            -- val = "  Plugin Profile",
                            -- val = "  Plugin Profile",
                            val = "  Plugin Profile",
                            on_press = function()
                                require("lazy").profile()
                            end,
                            opts = {
                                shortcut = "t",
                                keymap = { "n", "t", "<Cmd>Lazy profile<CR>", { noremap = true, silent = true, nowait = true } },
                            }
                        },
                        {
                            type = "button",
                            val = "  Quit",
                            on_press = function()
                                vim.cmd("qa")
                            end,
                            opts = {
                                shortcut = "q",
                                keymap = { "n", "q", "<Cmd>qa<CR>", { noremap = true, silent = true, nowait = true } },
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
                { type = "padding", val = 1 },
                { type = "group", val = projects_and_mru, opts = { inherit = { position = "center" } } },
                { type = "padding", val = 1 },
            },
            opts = {
                noautocmd = true
            }
        }

        vim.api.nvim_create_autocmd("User", {
            once = true,
            pattern = "LazyVimStarted",
            callback = function()
                require("alpha").redraw()
            end
        })

        vim.cmd [[ autocmd User AlphaReady set showtabline=0 | autocmd BufUnload <buffer> set showtabline=2 ]]
    end
}
