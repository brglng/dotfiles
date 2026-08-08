return {
    "anuvyklack/fold-preview.nvim",
    dependencies = "anuvyklack/keymap-amend.nvim",
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    opts = {
        default_keybindings = true
    }
}
