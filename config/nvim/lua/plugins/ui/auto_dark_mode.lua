return {
    "f-person/auto-dark-mode.nvim",
    -- event = "VeryLazy",
    lazy = false,
    opts = {
        update_interval = 1000,
        set_dark_mode = function()
            vim.api.nvim_set_option("background", "dark")
        end,
        set_light_mode = function()
            vim.api.nvim_set_option("background", "light")
        end,
    },
}
