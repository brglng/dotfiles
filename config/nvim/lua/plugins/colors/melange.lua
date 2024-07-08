return {
    "savq/melange-nvim",
    priority = 1000,
    config = function()
        local set_float_border_color = function ()
            local color_util = require('brglng.color_util')
            local Normal = vim.api.nvim_get_hl(0, { name = 'Normal', link = false })
            local NormalFloat = vim.api.nvim_get_hl(0, { name = 'NormalFloat', link = false })
            local WinSeparator = vim.api.nvim_get_hl(0, { name = 'WinSeparator', link = false })
            local FloatBorder = vim.api.nvim_get_hl(0, { name = 'FloatBorder', link = false })
            local Pmenu = vim.api.nvim_get_hl(0, { name = 'Pmenu', link = false })
            local PmenuSel = vim.api.nvim_get_hl(0, { name = 'PmenuSel', link = false })
            local PmenuThumb = vim.api.nvim_get_hl(0, { name = 'PmenuThumb', link = false })
            -- vim.api.nvim_set_hl(0, 'PmenuThumb', {
            --     fg = FloatBorder.bg,
            --     bg = WinSeparator.fg
            -- })
            if vim.o.background == 'dark' then
                vim.api.nvim_set_hl(0, 'Pmenu', {
                    fg = Pmenu.fg,
                    bg = color_util.add_value(Pmenu.bg, 0.02),
                })
                vim.api.nvim_set_hl(0, 'PmenuSel', {
                    fg = PmenuSel.fg,
                    bg = color_util.add_value(PmenuSel.bg, 0.02),
                })
                vim.api.nvim_set_hl(0, 'PmenuThumb', {
                    fg = PmenuThumb.fg,
                    bg = color_util.add_value(PmenuThumb.bg, 0.02),
                })
            else
                vim.api.nvim_set_hl(0, 'Pmenu', {
                    fg = Pmenu.fg,
                    bg = color_util.reduce_value(Pmenu.bg, 0.015)
                })
                vim.api.nvim_set_hl(0, 'PmenuSel', {
                    fg = PmenuSel.fg,
                    bg = color_util.reduce_value(PmenuSel.bg, 0.015)
                })
                vim.api.nvim_set_hl(0, 'PmenuThumb', {
                    fg = PmenuThumb.fg,
                    bg = color_util.reduce_value(PmenuThumb.bg, 0.015)
                })
            end
            vim.api.nvim_set_hl(0, 'FloatBorder', {
                fg = FloatBorder.fg,
                bg = Normal.bg
            })
        end
        vim.api.nvim_create_autocmd("ColorScheme", {
            pattern = "melange",
            callback = set_float_border_color,
        })
        vim.api.nvim_create_autocmd("OptionSet", {
            pattern = "background",
            callback = set_float_border_color
        })
    end
}
