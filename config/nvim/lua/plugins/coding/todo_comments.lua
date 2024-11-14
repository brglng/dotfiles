return {
    "folke/todo-comments.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim"
    },
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    cmd = { "TodoTrouble", "TodoTelescope" },
    keys = {
        { "<Leader>wt", "<Cmd>TodoTrouble<CR>", desc = "TODO" }
    },
    opts = {},
}
