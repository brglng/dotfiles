return {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
        enabled = false,
        indent = {
            char = "▏",
        },
        scope = {
            enabled = false
        },
        exclude = {
            filetypes = { "startify" }
        }
    }
}
