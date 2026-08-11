return {
    "Exafunction/windsurf.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        -- "hrsh7th/nvim-cmp",
    },
    event = { "InsertEnter", "CmdlineEnter" },
    opts = {
        enable_cmp_source = false,
        virtual_text = {
            enabled = true,
            filetypes = {
                TelescopePrompt = false,
                OverseerForm = false,
                ["neo-tree-popup"] = false,
            },
            default_filetype_enabled = true,
            key_bindings = {
                accept = "<Plug>(CodeiumAccept)",
                accept_word = "<Plug>(CodeiumAcceptWord)",
                accept_line = "<Plug>(CodeiumAcceptLine)",
                clear = "<C-]>",
                next = "<M-]>",
                prev = "<M-[>",
            }
        }
    },
    config = function(_, opts)
        require("codeium").setup(opts)
        vim.api.nvim_set_hl(0, "CodeiumSuggestion", { link = "Comment" })
    end
}
