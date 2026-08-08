return {
    "jbyuki/nabla.nvim",
    dependencies = {
        "williamboman/mason.nvim",
    },
    ft = (function()
        if vim.g.neovide or vim.fn.has("win32") == 1 then
            return { "norg", "markdown", "codecompanion" }
        else
            return { "norg" }
        end
    end)(),
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
