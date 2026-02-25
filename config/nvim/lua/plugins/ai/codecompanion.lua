return {
    "olimorris/codecompanion.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
        "zbirenbaum/copilot.lua",
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
                model = "gemini-3-pro-preview",
                keymaps = {
                    send = {
                        -- modes = { n = "<C-Enter>", i = "<C-Enter>" },
                    },
                    close = {
                        modes = { n = "q", i = "<C-d>" },
                    }
                }
            },
            inline = {
                adaptor = "copilot",
                model = "gemini-3-pro-preview",
            },
            cmd = {
                adaptor = "copilot",
                model = "gemini-3-pro-preview",
            },
        },
        display = {
            chat = {
                window = {
                    position = "right",
                }
            }
        },
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
