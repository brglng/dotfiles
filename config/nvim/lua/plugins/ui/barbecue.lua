return {
    --[[ "utilyre/barbecue.nvim",
    name = "barbecue",
    enabled = false,
    version = "*",
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    dependencies = {
        "SmiteshP/nvim-navic",
        "echasnovski/mini.icons",
    },
    opts = {
        exclude_filetypes = { "netrw", "toggleterm" }
    } ]]
}
