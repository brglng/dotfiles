local api = vim.api
local base = require("notify.render.base")
local stages_util = require("notify.stages.util")

return {
    "rcarriga/nvim-notify",
    opts = {
        on_open = function(win)
            vim.api.nvim_win_set_config(win, {
                -- border = { '🭽', '▔', '🭾', '▕', '🭿', '▁', '🭼', '▏' },
                focusable = false,
            })
        end,
        top_down = false,
        render = "wrapped-compact"
    },
    config = function(_, opts)
        require("notify").setup(opts)
        local set_notify_colors = function()
            local colorutil = require('brglng.colorutil')
            local Normal = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
            local NormalFloat = vim.api.nvim_get_hl(0, { name = "NormalFloat", link = false })
            local WinSeparator = vim.api.nvim_get_hl(0, { name = "WinSeparator", link = false })
            local border_fg, bg
            -- if vim.o.background == 'dark' then
            --     border_fg = colorutil.reduce_value(Normal.bg, 0.1)
            --     bg = colorutil.add_value(NormalFloat.bg, 0.02)
            -- else
            --     border_fg = colorutil.transparency(WinSeparator.fg, Normal.bg, 0.3)
            --     bg = colorutil.reduce_value(NormalFloat.bg, 0.02)
            -- end

            -- vim.api.nvim_set_hl(0, "NotifyERRORBorder", {
            --     fg = border_fg,
            --     bg = bg
            -- })
            -- vim.api.nvim_set_hl(0, "NotifyWARNBorder", {
            --     fg = border_fg,
            --     bg = bg
            -- })
            -- vim.api.nvim_set_hl(0, "NotifyINFOBorder", {
            --     fg = border_fg,
            --     bg = bg
            -- })
            -- vim.api.nvim_set_hl(0, "NotifyDEBUGBorder", {
            --     fg = border_fg,
            --     bg = bg
            -- })
            -- vim.api.nvim_set_hl(0, "NotifyTRACEBorder", {
            --     fg = border_fg,
            --     bg = bg
            -- })
            -- vim.api.nvim_set_hl(0, "NotifyERRORBody", {
            --     fg = NormalFloat.fg,
            --     bg = bg
            -- })
            -- vim.api.nvim_set_hl(0, "NotifyWARNBody", {
            --     fg = NormalFloat.fg,
            --     bg = bg
            -- })
            -- vim.api.nvim_set_hl(0, "NotifyINFOBody", {
            --     fg = NormalFloat.fg,
            --     bg = bg
            -- })
            -- vim.api.nvim_set_hl(0, "NotifyDEBUGBody", {
            --     fg = NormalFloat.fg,
            --     bg = bg
            -- })
            -- vim.api.nvim_set_hl(0, "NotifyTRACEBody", {
            --     fg = NormalFloat.fg,
            --     bg = bg
            -- })
            -- vim.api.nvim_set_hl(0, "NotifyERRORBody", { link = "NormalFloat" })
            -- vim.api.nvim_set_hl(0, "NotifyWARNBody", { link = "NormalFloat" })
            -- vim.api.nvim_set_hl(0, "NotifyINFOBody", { link = "NormalFloat" })
            -- vim.api.nvim_set_hl(0, "NotifyDEBUGBody", { link = "NormalFloat" })
            -- vim.api.nvim_set_hl(0, "NotifyTRACEBody", { link = "NormalFloat" })
            vim.api.nvim_set_hl(0, 'NotifyINFOIcon', { link = 'DiagnosticInfo' })
            vim.api.nvim_set_hl(0, 'NotifyINFOTitle', { link = 'DiagnosticInfo' })
            vim.api.nvim_set_hl(0, 'NotifyWARNIcon', { link = 'DiagnosticWarn' })
            vim.api.nvim_set_hl(0, 'NotifyWARNTitle', { link = 'DiagnosticWarn' })
            vim.api.nvim_set_hl(0, 'NotifyERRORIcon', { link = 'DiagnosticError' })
            vim.api.nvim_set_hl(0, 'NotifyERRORTitle', { link = 'DiagnosticError' })
            -- vim.api.nvim_set_hl(0, 'NotifyDEBUGTitle', { link = 'DiagnosticInfo' })
            -- vim.api.nvim_set_hl(0, 'NotifyTRACETitle', { link = 'DiagnosticInfo' })
        end

        vim.api.nvim_create_autocmd("ColorScheme", {
            pattern = "*",
            callback = set_notify_colors
        })
        vim.api.nvim_create_autocmd("OptionSet", {
            pattern = "background",
            callback = set_notify_colors
        })
    end
}
