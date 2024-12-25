return {
    "savq/melange-nvim",
    priority = 1000,
    config = function()
        local set_melange_color = function ()
            local colorutil = require('brglng.colorutil')
            local Normal = vim.api.nvim_get_hl(0, { name = 'Normal', link = false })
            local NormalFloat = vim.api.nvim_get_hl(0, { name = 'NormalFloat', link = false })
            local FloatTitle = vim.api.nvim_get_hl(0, { name = 'FloatTitle', link = false })
            local WinSeparator = vim.api.nvim_get_hl(0, { name = 'WinSeparator', link = false })
            local FloatBorder = vim.api.nvim_get_hl(0, { name = 'FloatBorder', link = false })
            local FloatTitle = vim.api.nvim_get_hl(0, { name = 'FloatTitle', link = false })
            local Pmenu = vim.api.nvim_get_hl(0, { name = 'Pmenu', link = false })
            local PmenuSel = vim.api.nvim_get_hl(0, { name = 'PmenuSel', link = false })
            local PmenuThumb = vim.api.nvim_get_hl(0, { name = 'PmenuThumb', link = false })
            -- vim.api.nvim_set_hl(0, 'PmenuThumb', {
            --     fg = FloatBorder.bg,
            --     bg = WinSeparator.fg
            -- })
            --[[ if vim.o.background == 'dark' then
                vim.api.nvim_set_hl(0, 'Pmenu', {
                    fg = Pmenu.fg,
                    bg = colorutil.add_value(Pmenu.bg, 0.02),
                })
                vim.api.nvim_set_hl(0, 'PmenuSel', {
                    fg = PmenuSel.fg,
                    bg = colorutil.add_value(PmenuSel.bg, 0.02),
                })
                vim.api.nvim_set_hl(0, 'PmenuThumb', {
                    fg = PmenuThumb.fg,
                    bg = colorutil.add_value(PmenuThumb.bg, 0.02),
                })
            else
                vim.api.nvim_set_hl(0, 'Pmenu', {
                    fg = Pmenu.fg,
                    bg = colorutil.reduce_value(Pmenu.bg, 0.015)
                })
                vim.api.nvim_set_hl(0, 'PmenuSel', {
                    fg = PmenuSel.fg,
                    bg = colorutil.reduce_value(PmenuSel.bg, 0.015)
                })
                vim.api.nvim_set_hl(0, 'PmenuThumb', {
                    fg = PmenuThumb.fg,
                    bg = colorutil.reduce_value(PmenuThumb.bg, 0.015)
                })
            end ]]
            if not vim.g.neovide then
                if vim.o.background == 'dark' then
                    vim.api.nvim_set_hl(0, 'FloatBorder', {
                        fg = colorutil.reduce_value(Normal.bg, 0.3),
                        bg = Normal.bg
                    })
                else
                    vim.api.nvim_set_hl(0, 'FloatBorder', {
                        fg = colorutil.transparency(FloatTitle.fg, Normal.bg, 0.5),
                        bg = Normal.bg
                    })
                end
            else
                vim.api.nvim_set_hl(0, 'FloatBorder', {
                    fg = colorutil.transparency(FloatTitle.fg, NormalFloat.bg, 0.5),
                    bg = NormalFloat.bg
                })
            end
            -- vim.api.nvim_set_hl(0, 'PmenuThumb', {
            --     fg = PmenuThumb.fg,
            --     bg = (function()
            --         if vim.o.background == 'dark' then
            --             return colorutil.add_value(PmenuThumb.bg, 0.1)
            --         else
            --             return colorutil.reduce_value(PmenuThumb.bg, 0.1)
            --         end
            --     end)()
            -- })
        end
        vim.api.nvim_create_autocmd("ColorScheme", {
            pattern = "melange",
            callback = set_melange_color,
        })
        vim.api.nvim_create_autocmd("OptionSet", {
            pattern = "background",
            callback = set_melange_color
        })
        set_melange_color()
    end
}
