local ft = { "markdown", "codecompanion" }

return {
    "jbyuki/nabla.nvim",
    dependencies = {
        "williamboman/mason.nvim",
    },
    ft = ft,
    cond = (vim.g.neovide or vim.fn.has("win32") == 1),
    lazy = true,
    config = function()
        vim.api.nvim_create_autocmd("FileType", {
            pattern = ft,
            callback = function()
                require("nabla").enable_virt({
                    autogen = true,     -- auto-regenerate ASCII art when exiting insert mode
                    silent = true,      -- silents error messages
                })
            end,
        })
    end,
}
