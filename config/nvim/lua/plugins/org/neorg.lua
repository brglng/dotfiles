return {
    "nvim-neorg/neorg",
    dependencies = {
        "3rd/image.nvim",
        -- "vhyrro/luarocks.nvim",
    },
    lazy = true, -- Disable lazy loading as some `lazy.nvim` distributions set `lazy = true` by default
    version = "*", -- Pin Neorg to the latest stable release
    -- build = ":Neorg sync-parsers",
    ft = "norg",
    cmd = "Neorg",
    config = function()
        require("neorg").setup {
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
                ["core.defaults"] = {},
                ["core.dirman"] = {
                    config = {
                        workspaces = {
                            notes = "~/Syncthing/sync/notes"
                        },
                        default_workspace = "notes"
                    }
                },
                ["core.highlights"] = {},
                ["core.integrations.image"] = {},
                ["core.integrations.nvim-cmp"] = {},
                ["core.integrations.treesitter"] = {},
                ["core.keybinds"] = {
                    config = {
                        default_keybinds = true,
                        -- neorg_leader = ","
                    }
                },
                ["core.latex.renderer"] = {
                    config = {
                        conceal = true,
                        -- debounce_ms = 30,
                        -- dpi = 192,
                        render_on_enter = true
                    }
                }
            }
        }
    end
}
