return {
    "nvimtools/none-ls.nvim",
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    enabled = true,
    dependencies = {
        "nvim-lua/plenary.nvim",
        "williamboman/mason.nvim",
        "nvimtools/none-ls-extras.nvim",
    },
    config = function(_, opts)
        local null_ls = require("null-ls")
        require("null-ls").setup {
            sources = {
                null_ls.builtins.diagnostics.cmake_lint,
                null_ls.builtins.formatting.prettierd,
                null_ls.builtins.formatting.stylua,
            }
        }
    end,
}
