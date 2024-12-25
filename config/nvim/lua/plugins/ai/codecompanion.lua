return {
    "olimorris/codecompanion.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
        "github/copilot.vim"
    },
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    config = true
}
