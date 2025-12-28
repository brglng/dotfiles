return {
    "nvim-neorg/neorg",
    dependencies = {
        -- "3rd/image.nvim",
        -- "folke/snacks.nvim",
        "jbyuki/nabla.nvim",
        "nvim-treesitter/nvim-treesitter",
        { "nvim-neorg/neorg-telescope" },
        { "benlubas/neorg-conceal-wrap" },
        { "benlubas/neorg-interim-ls" },
        {
            -- "benlubas/neorg-query",
            "brglng/neorg-query",
            branch = "feature/windows",
            -- build = (function()
            --     if vim.fn.has('win32') then
            --         return false
            --     else
            --         return nil
            --     end
            -- end)(),
        },
        { dir = vim.fs.normalize("~/github/neorg-auto-summary") }
    },
    -- lazy = true, -- Disable lazy loading as some `lazy.nvim` distributions set `lazy = true` by default
    version = "*", -- Pin Neorg to the latest stable release
    -- build = ":Neorg sync-parsers",
    ft = "norg",
    cmd = "Neorg",
    opts = {
        load = {
            ["core.completion"] = {
                config = {
                    engine = { module_name = "external.lsp-completion" }
                }
            },
            ["core.concealer"] = {
                config = {
                    -- icon_preset = "diamond"
                }
            },
            ["core.defaults"] = {
                config = {
                    disable = {}
                }
            },
            ["core.dirman"] = {
                config = {
                    workspaces = {
                        mynorg = "~/github/mynorg"
                    },
                    default_workspace = "mynorg"
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
                config = {
                    journal_folder = "library",
                    strategy = "%Y/%m/%d-%H-%M-%S/index.norg",
                }
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
                    autocmd = true,
                }
            },
            ["external.conceal-wrap"] = {},
            ["external.interim-ls"] = {
                config = {
                    completion_provider = {
                        -- Enable or disable the completion provider
                        enable = true,

                        -- Show file contents as documentation when you complete a file name
                        documentation = true,

                        -- Try to complete categories provided by Neorg Query. Requires `benlubas/neorg-query`
                        categories = true,

                        -- suggest heading completions from the given file for `{@x|}` where `|` is your cursor
                        -- and `x` is an alphanumeric character. `{@name}` expands to `[name]{:$/people:# name}`
                        people = {
                            enable = false,

                            -- path to the file you're like to use with the `{@x` syntax, relative to the
                            -- workspace root, without the `.norg` at the end.
                            -- ie. `folder/people` results in searching `$/folder/people.norg` for headings.
                            -- Note that this will change with your workspace, so it fails silently if the file
                            -- doesn't exist
                            path = "people",
                        }
                    }
                }
            },
            ["external.query"] = {},
        }
    },
    config = function(_, opts)
        if vim.g.neovide or vim.fn.has("win32") == 1 then
            opts.load["core.defaults"].config.disable = {
                "core.integrations.image",
                "core.latex.renderer"
            }
        else
            -- opts.load["core.integrations.image"] = {}
            -- opts.load["core.latex.renderer"] = {
            --     config = {
            --         conceal = true,
            --         render_on_enter = true,
            --     }
            -- }
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
