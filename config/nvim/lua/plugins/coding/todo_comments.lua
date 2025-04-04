return {
    "folke/todo-comments.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim"
    },
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    cmd = { "TodoTrouble", "TodoTelescope" },
    keys = {
        { "<Leader>cT", "<Cmd>SidebarToggle trouble_todo<CR>", desc = "TODO" }
    },
    opts = {},
}
