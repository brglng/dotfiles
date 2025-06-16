return {
    "3rd/image.nvim",
    cond = not vim.g.neovide and vim.fn.has("win32") == 0,
    lazy = true,
    opts = {}
}
