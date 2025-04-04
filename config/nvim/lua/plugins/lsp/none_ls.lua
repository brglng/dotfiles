return {
    {
        "nvimtools/none-ls.nvim",
        event = { "BufReadPost", "BufWritePost", "BufNewFile" },
        dependencies = {
            "nvim-lua/plenary.nvim",
            "williamboman/mason.nvim",
        },
        opts = {}
    },
    {
        "jay-babu/mason-null-ls.nvim",
        event = { "BufReadPost", "BufWritePost", "BufNewFile" },
        opts = {}
    }
}
