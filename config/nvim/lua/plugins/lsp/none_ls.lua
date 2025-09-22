return {
    "nvimtools/none-ls.nvim",
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    enabled = true,
    dependencies = {
        "nvim-lua/plenary.nvim",
        "williamboman/mason.nvim",
    },
    opts = {}
}
