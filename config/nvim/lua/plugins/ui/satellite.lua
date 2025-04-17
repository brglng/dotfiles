return {
    "https://github.com/lewis6991/satellite.nvim",
    cond = false,
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    opts = {
        current_only = false,
        excluded_filetypes = { "neo-tree" },
        width = 1,
    }
}
