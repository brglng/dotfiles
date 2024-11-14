return {
    "folke/trouble.nvim",
    cmd = "Trouble",
    dependencies = {
        "nvim-tree/nvim-web-devicons"
    },
    opts = {
        focus = true
    },
    keys = {
        { "<Leader>cd", "<Cmd>Trouble lsp_definitions<CR>", desc = "Definitions" },
        { "<Leader>ci", "<Cmd>Trouble lsp_implementations<CR>", desc = "Implementations" },
        { "<Leader>cr", "<Cmd>Trouble lsp_references<CR>", desc = "References" },
        { "<Leader>ct", "<Cmd>Trouble lsp_type_definitions<CR>", desc = "Type Definitions" }
    }
}
