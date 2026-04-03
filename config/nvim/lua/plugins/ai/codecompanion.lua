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
    },
    opts = {
        strategies = {
            chat = {
                adaptor = "copilot",
                model = "gemini-3.1-pro-preview",
                keymaps = {
                    send = {
                        -- modes = { n = "<C-CR>", i = "<C-CR>" },
                    },
                    close = {
                        modes = { n = "q", i = "<C-c>" },
                    }
                }
            },
            inline = {
                adaptor = "copilot",
                model = "gemini-3.1-pro-preview",
            },
            cmd = {
                adaptor = "copilot",
                model = "gemini-3.1-pro-preview",
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
        { "<M-i>", ":CodeCompanionChat", mode = { "v" }, desc = "CodeCompanionChat" },
        { "<leader>c/", "<Cmd>CodeCompanionActions<CR>", mode = { "n", "v" }, desc = "CodeCompanionActions" },
    }
}
