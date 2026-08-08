return {
    "f-person/auto-dark-mode.nvim",
    cond = vim.g.neovide,
    -- lazy = false,
    -- priority = 999,
    event = "VeryLazy",
    opts = {
        update_interval = 1000,
        set_dark_mode = function()
            vim.o.background = "dark"
        end,
        set_light_mode = function()
            vim.o.background = "light"
        end,
    },
    config = function (_, opts)
        require("auto-dark-mode").setup(opts)
    end
}
