return {
    "jbyuki/nabla.nvim",
    dependencies = {
        "williamboman/mason.nvim",
    },
    ft = { "markdown", "norg", "codecompanion" },
    lazy = true,
    config = function()
        require("nabla").enable_virt({
            autogen = true,     -- auto-regenerate ASCII art when exiting insert mode
            silent = true,      -- silents error messages
        })
    end,
}
