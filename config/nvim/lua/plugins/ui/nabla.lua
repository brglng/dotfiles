local ft
if vim.g.neovide then
    ft = { "norg" }
else
    ft = { "norg", "markdown", "codecompanion" }
end

return {
    "jbyuki/nabla.nvim",
    dependencies = {
        "williamboman/mason.nvim",
    },
    ft = ft,
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
