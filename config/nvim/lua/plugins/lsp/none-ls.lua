return {
    "nvimtools/none-ls.nvim",
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    opts = {}
}
