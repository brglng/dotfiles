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
            key_bindings = {
                accept = "<Plug>(CodiumAccept)",
                accept_word = "<Plug>(CodiumAcceptWord)",
                accept_line = "<Plug>(CodiumAcceptLine)",
                clear = "<Plug>(CodiumClear)",
            }
        }
    },
    config = function(_, opts)
        require("codeium").setup(opts)
        vim.api.nvim_set_hl(0, "CodeiumSuggestion", { link = "Comment" })
    end
}
