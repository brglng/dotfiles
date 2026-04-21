return {
    "olimorris/codecompanion.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
        "zbirenbaum/copilot.lua",
        "ravitemer/codecompanion-history.nvim",
        "franco-ruggeri/codecompanion-spinner.nvim"
    },
    -- event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    enabled = true,
    cmd = {
        "CodeCompanion",
        "CodeCompanionActions",
        "CodeCompanionChat",
        "CodeCompanionCmd",
        "CodeCompanionCLI",
        "CodeCompanionHistory",
        "CodeCompanionSummaries"
    },
    opts = {
        adapters = {
            http = {
                opts = {
                    allow_insecure = true,
                    proxy = "socks5://127.0.0.1:1086",
                    show_model_choices = true
                }
            }
        },
        interactions = {
            chat = {
                adapter = {
                    name = "copilot",
                    model = "claude-sonnet-4.6",
                },
                keymaps = {
                    -- send = {
                    --     modes = { n = "<C-CR>", i = "<C-CR>" },
                    -- },
                    -- close = {
                    --     modes = { n = "q", i = "<C-c>" },
                    -- }
                },
                opts = {
                    system_prompt = function(ctx)
                        return ctx.default_system_prompt .. string.format(
                            [[Additional context:
All non-code text responses must be written in the same language as the language of the user's request regardless of the language of the code.
All code including comments must be written in English regardless of the language of the user's request.
The user's current working directory is %s.
The current date is %s.
The user's Neovim version is %s.
The user is working on a %s machine. Please respond with system specific commands if applicable.
]],
                            ctx.language,
                            ctx.cwd,
                            ctx.date,
                            ctx.nvim_version,
                            ctx.os
                        )
                    end,
                }
            },
            inline = {
                adapter = {
                    name = "copilot",
                    model = "claude-sonnet-4.6",
                },
            },
            cmd = {
                adapter = {
                    name = "copilot",
                    model = "claude-sonnet-4.6",
                },
            },
        },
        display = {
            chat = {
                window = {
                    position = "right",
                }
            }
        },
        extensions = {
            history = {
                enabled = true,
                opts = {
                    picker_keymaps = {
                        rename = { n = "r", i = "<M-r>" },
                        delete = { n = "d", i = "<C-d>" },
                        duplicate = { n = "<C-y>", i = "<C-y>" },
                    }
                }
            },
            spinner = {}
        }
    },
    init = function ()
        vim.cmd([[cab cc CodeCompanion]])
    end,
    config = function(_, opts)
        require("codecompanion").setup(opts)
    end,
    keys = {
        { "<leader>cc", "<Cmd>CodeCompanionChat Toggle<CR>", mode = { "n", "v" }, desc = "CodeCompanionChat Toggle" },
        { "<leader>ca", "<Cmd>CodeCompanionChat Add<CR>", mode = { "n", "v" }, desc = "CodeCompanionChat Add" },
        { "<leader>ch", "<Cmd>CodeCompanionHistory<CR>", mode = { "n", "v" }, desc = "CodeCompanionHistory" },
        { "<M-i>", ":CodeCompanionChat", mode = { "v" }, desc = "CodeCompanionChat" },
        { "<leader>c/", "<Cmd>CodeCompanionActions<CR>", mode = { "n", "v" }, desc = "CodeCompanionActions" },
    }
}
