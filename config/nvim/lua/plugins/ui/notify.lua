local api = vim.api
local base = require("notify.render.base")
local stages_util = require("notify.stages.util")

return {
    "rcarriga/nvim-notify",
    config = function()
        local set_notify_colors = function()
            -- local normal_float = vim.api.nvim_get_hl(0, { name = "NormalFloat", link = false })
            -- vim.api.nvim_set_hl(0, "NotifyERRORBorder", {
            --     fg = normal_float.bg,
            --     bg = normal_float.bg
            -- })
            -- vim.api.nvim_set_hl(0, "NotifyWARNBorder", {
            --     fg = normal_float.bg,
            --     bg = normal_float.bg
            -- })
            -- vim.api.nvim_set_hl(0, "NotifyINFOBorder", {
            --     fg = normal_float.bg,
            --     bg = normal_float.bg
            -- })
            -- vim.api.nvim_set_hl(0, "NotifyDEBUGBorder", {
            --     fg = normal_float.bg,
            --     bg = normal_float.bg
            -- })
            -- vim.api.nvim_set_hl(0, "NotifyTRACEBorder", {
            --     fg = normal_float.bg,
            --     bg = normal_float.bg
            -- })
            vim.api.nvim_set_hl(0, "NotifyERRORBody", { link = "NormalFloat" })
            vim.api.nvim_set_hl(0, "NotifyWARNBody", { link = "NormalFloat" })
            vim.api.nvim_set_hl(0, "NotifyINFOBody", { link = "NormalFloat" })
            vim.api.nvim_set_hl(0, "NotifyDEBUGBody", { link = "NormalFloat" })
            vim.api.nvim_set_hl(0, "NotifyTRACEBody", { link = "NormalFloat" })
        end

        -- vim.api.nvim_create_autocmd("ColorScheme", {
        --     pattern = "*",
        --     callback = set_notify_colors
        -- })
        -- vim.api.nvim_create_autocmd("OptionSet", {
        --     pattern = "background",
        --     callback = set_notify_colors
        -- })

        require("notify").setup {
            on_open = function(win)
                vim.api.nvim_win_set_config(win, {
                    focusable = false,
                })
            end,
            top_down = false,
            render = "wrapped-compact"
        }
    end
}
