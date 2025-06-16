return {
    "nvim-neorg/neorg",
    dependencies = {
        "3rd/image.nvim",
        -- "folke/snacks.nvim",
    },
    lazy = true, -- Disable lazy loading as some `lazy.nvim` distributions set `lazy = true` by default
    version = "*", -- Pin Neorg to the latest stable release
    -- build = ":Neorg sync-parsers",
    ft = "norg",
    cmd = "Neorg",
    opts = {
        load = {
            ["core.completion"] = {
                config = {
                    engine = "nvim-cmp", name = "[Norg]"
                }
            },
            ["core.concealer"] = {
                config = {
                    icon_preset = "diamond"
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
                        notes = "~/Syncthing/notes"
                    },
                    default_workspace = "notes"
                }
            },
            ["core.highlights"] = {},
            ["core.integrations.nvim-cmp"] = {},
            ["core.integrations.treesitter"] = {},
            ["core.keybinds"] = {
                config = {
                    default_keybinds = true,
                    -- neorg_leader = ","
                }
            },
        }
    },
    config = function(_, opts)
        if vim.g.neovide or vim.fn.has("win32") then
            opts.load["core.defaults"].config.disable = {
                "core.integrations.image",
                "core.latex.renderer"
            }
        else
            opts.load["core.integrations.image"] = {}
            opts.load["core.latex.renderer"] = {
                config = {
                    conceal = true,
                    render_on_enter = true,
                }
            }
        end
        require("neorg").setup(opts)
    end
}
