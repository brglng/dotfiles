return {
    "nvim-neorg/neorg",
    dependencies = {
        { "3rd/image.nvim", cond = ((not vim.g.neovide) and vim.fn.has("win32") == 0) },
        { "jbyuki/nabla.nvim" },
        "nvim-treesitter/nvim-treesitter",
        { "nvim-neorg/neorg-telescope" },
        { "benlubas/neorg-conceal-wrap" },
        -- { "benlubas/neorg-interim-ls" },
        -- {
        --     "benlubas/neorg-query",
        --     -- "brglng/neorg-query",
        --     -- branch = "feature/windows",
        -- },
        { dir = vim.fs.normalize("~/github/neorg-auto-summary") },
        { dir = vim.fs.normalize("~/github/neorg-nabla") },
        { dir = vim.fs.normalize("~/github/neorg-new") },
    },
    -- lazy = true, -- Disable lazy loading as some `lazy.nvim` distributions set `lazy = true` by default
    -- version = "*", -- Pin Neorg to the latest stable release
    -- build = ":Neorg sync-parsers",
    ft = "norg",
    cmd = "Neorg",
    opts = {
        load = {
            -- ["core.completion"] = {
            --     config = {
            --         engine = { module_name = "external.lsp-completion" }
            --     }
            -- },
            ["core.concealer"] = {
                config = {
                    icon_preset = "diamond"
                }
            },
            ["core.defaults"] = {
                config = {
                    disable = {
                        "core.latex.renderer"
                    }
                }
            },
            ["core.dirman"] = {
                config = {
                    workspaces = {
                        mynorg = "~/github/mynorg"
                    },
                    default_workspace = function()
                        if vim.fn.argc(-1) ~= 0 then
                            return nil
                        end
                        local dirman = require("neorg").modules.get_module("core.dirman")
                        local cwd = vim.uv.cwd()
                        if not cwd then
                            return nil
                        end
                        cwd = vim.fs.normalize(vim.fs.abspath(cwd))
                        for name, path in pairs(dirman.get_workspaces()) do
                            if vim.startswith(cwd, tostring(path:resolve():to_absolute())) then
                                return name
                            end
                        end
                    end
                }
            },
            ["core.esupports.metagen"] = {
                config = {
                    author = "Zhaosheng Pan",
                    type = "auto"
                }
            },
            ["core.export"] = {},
            ["core.highlights"] = {},
            ["core.integrations.nvim-cmp"] = {},
            ["core.integrations.treesitter"] = {},
            ["core.integrations.telescope"] = {
                config = {
                    insert_file_link = {
                        -- Whether to show the title preview in telescope. Affects performance with a large
                        -- number of files.
                        show_title_preview = true,
                    },
                }
            },
            ["core.journal"] = {
                config = {}
            },
            ["core.keybinds"] = {
                config = {
                    default_keybinds = true,
                    -- neorg_leader = ","
                }
            },
            ["core.summary"] = {
                config = {
                    strategy = "default"
                }
            },
            ["external.auto-summary"] = {
                config = {
                    name = "index.norg",
                    summary_on_launch = true,
                    update_on_change = true,
                    inject_metadata = true,
                }
            },
            ["external.conceal-wrap"] = {},
            -- ["external.interim-ls"] = {
            --     config = {
            --         completion_provider = {
            --             -- Enable or disable the completion provider
            --             enable = true,
            --
            --             -- Show file contents as documentation when you complete a file name
            --             documentation = true,
            --
            --             -- Try to complete categories provided by Neorg Query. Requires `benlubas/neorg-query`
            --             categories = true,
            --
            --             -- suggest heading completions from the given file for `{@x|}` where `|` is your cursor
            --             -- and `x` is an alphanumeric character. `{@name}` expands to `[name]{:$/people:# name}`
            --             people = {
            --                 enable = false,
            --
            --                 -- path to the file you're like to use with the `{@x` syntax, relative to the
            --                 -- workspace root, without the `.norg` at the end.
            --                 -- ie. `folder/people` results in searching `$/folder/people.norg` for headings.
            --                 -- Note that this will change with your workspace, so it fails silently if the file
            --                 -- doesn't exist
            --                 path = "people",
            --             }
            --         }
            --     }
            -- },
            -- ["external.query"] = {},
            ["external.nabla"] = {
                config = {
                    render_on_enter = true,
                    conceal_math_tags = true,
                }
            },
            ["external.new"] = {
                config = {
                    filename = function(args)
                        return os.date("%Y/%m/%d-%H-%M-%S/") .. table.concat(vim.tbl_map(function(arg)
                            return vim.fn.substitute(vim.fn.tolower(arg), "\\s\\+", "-", "g")
                        end, args), "-")
                    end
                }
            }
        }
    },
    config = function(_, opts)
        if vim.g.neovide or vim.fn.has("win32") == 1 then
            table.insert(opts.load["core.defaults"].config.disable, "core.integrations.image")
        else
            opts.load["core.integrations.image"] = {}
        --     opts.load["core.latex.renderer"] = {
        --         config = {
        --             conceal = true,
        --             render_on_enter = true,
        --         }
        --     }
        end
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "norg",
            callback = function()
                vim.opt_local.cursorline = false
                vim.opt_local.softtabstop = 2
                vim.opt_local.shiftwidth = 2
            end
        })
        require("neorg").setup(opts)
    end
}
