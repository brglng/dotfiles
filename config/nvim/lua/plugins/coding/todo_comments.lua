return {
    "folke/todo-comments.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim"
    },
    opts = {},
    keys = {
        { "<Leader>wt", "<Cmd>TodoTrouble<CR>", desc = "TODO" }
    }
}
