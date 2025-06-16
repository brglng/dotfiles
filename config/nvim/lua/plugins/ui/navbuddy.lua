return {
    "SmiteshP/nvim-navbuddy",
    enabled = false,
    cmd = "Navbuddy",
    dependencies = {
        "neovim/nvim-lspconfig",
        "SmiteshP/nvim-navic",
        "MunifTanjim/nui.nvim",
    },
    opts = {
        lsp = {
            auto_attach = true
        }
    },
    keys = {
        { "<Leader>cn", mode = "n", "<Cmd>Navbuddy<CR>", desc = "Navigate" },
    }
}
