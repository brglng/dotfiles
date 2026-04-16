return {
    "jbyuki/nabla.nvim",
    dependencies = {
        "williamboman/mason.nvim",
    },
    ft = { "norg", "markdown", "codecompanion" },
    lazy = true,
    config = function()
        if vim.g.neovide or vim.fn.has("win32") == 1 then
            vim.api.nvim_create_autocmd("FileType", {
                pattern = { "markdown", "codecompanion" },
                callback = function()
                    require("nabla").enable_virt({
                        autogen = true,     -- auto-regenerate ASCII art when exiting insert mode
                        silent = true,      -- silents error messages
                    })
                end,
            })
        end
    end,
}
