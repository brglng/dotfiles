local ft = { "markdown", "codecompanion" }
-- if vim.fn.hostname == "zhaosheng-MacBookAir2022.local" then
    table.insert(ft, "norg")
-- end

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
