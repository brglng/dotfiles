return {
    --[[ "utilyre/barbecue.nvim",
    name = "barbecue",
    enabled = false,
    version = "*",
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    dependencies = {
        "SmiteshP/nvim-navic",
        "nvim-tree/nvim-web-devicons",
    },
    opts = {
        exclude_filetypes = { "netrw", "toggleterm" }
    } ]]
}
