return {
    "rose-pine/neovim",
    name = "rose-pine",
    cond = true,
    priority = 1000,
    config = function()
        -- local function set_rose_pine_color(is_autocmd)
        --     if is_autocmd and not vim.g.colors_name:find("^rose-pine") then
        --         return
        --     end
        --     local NormalFloat = vim.api.nvim_get_hl(0, { name = 'NormalFloat', link = false })
        --     local FloatBorder = vim.api.nvim_get_hl(0, { name = 'FloatBorder', link = false })
        --     if not vim.g.neovide then
        --         vim.api.nvim_set_hl(0, 'FloatBorder', {
        --             fg = FloatBorder.fg,
        --             bg = NormalFloat.bg
        --         })
        --     end
        -- end
        -- set_rose_pine_color(false)
        -- vim.api.nvim_create_autocmd("ColorScheme", {
        --     pattern = "melange",
        --     callback = function() set_rose_pine_color(true) end,
        -- })
        -- vim.api.nvim_create_autocmd("OptionSet", {
        --     pattern = "background",
        --     callback = function() set_rose_pine_color(true) end,
        -- })
    end
}
