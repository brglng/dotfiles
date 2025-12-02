return {
    "catppuccin/nvim",
    name = "catppuccin",
    cond = true,
    priority = 1000,
    config = function()
        local brglng = require("brglng")
        brglng.hl.modify_colorscheme("catppuccin", function(background)
            if background == "dark" then
                vim.g.terminal_color_0 = "#45475a"
                vim.g.terminal_color_1 = "#f38ba8"
                vim.g.terminal_color_2 = "#a6e3a1"
                vim.g.terminal_color_3 = "#f9e2af"
                vim.g.terminal_color_4 = "#89b4fa"
                vim.g.terminal_color_5 = "#f5c2e7"
                vim.g.terminal_color_6 = "#94e2d5"
                vim.g.terminal_color_7 = "#bac2de"
                vim.g.terminal_color_8 = "#585b70"
                vim.g.terminal_color_9 = "#f38ba8"
                vim.g.terminal_color_10 = "#a6e3a1"
                vim.g.terminal_color_11 = "#f9e2af"
                vim.g.terminal_color_12 = "#89b4fa"
                vim.g.terminal_color_13 = "#f5c2e7"
                vim.g.terminal_color_14 = "#94e2d5"
                vim.g.terminal_color_15 = "#a6adc8"
            else
                vim.g.terminal_color_0 = "#5c5f77"
                vim.g.terminal_color_1 = "#d20f39"
                vim.g.terminal_color_2 = "#40a02b"
                vim.g.terminal_color_3 = "#df8e1d"
                vim.g.terminal_color_4 = "#1e66f5"
                vim.g.terminal_color_5 = "#ea76cb"
                vim.g.terminal_color_6 = "#179299"
                vim.g.terminal_color_7 = "#acb0be"
                vim.g.terminal_color_8 = "#6c6f85"
                vim.g.terminal_color_9 = "#d20f39"
                vim.g.terminal_color_10 = "#40a02b"
                vim.g.terminal_color_11 = "#df8e1d"
                vim.g.terminal_color_12 = "#1e66f5"
                vim.g.terminal_color_13 = "#ea76cb"
                vim.g.terminal_color_14 = "#179299"
                vim.g.terminal_color_15 = "#bcc0cc"
            end
        end)
    end
}
