return {
    "nvim-neorg/neorg",
    dependencies = {
        "3rd/image.nvim",
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
        if vim.g.neovide then
            opts.load["core.defaults"].config.disable = {
                "core.integrations.image",
                "core.latex.renderer"
            }
        else
            opts.load["core.integrations.image"] = {}
            opts.load["core.latex.renderer"] = {
                config = {
                    conceal = false,
                    -- debounce_ms = 30,
                    -- dpi = 720,
                    render_on_enter = true,
                    scale = 1
                }
            }
        end
        require("neorg").setup(opts)
    end
}
