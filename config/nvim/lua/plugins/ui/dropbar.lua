return {
    'Bekaboo/dropbar.nvim',
    -- optional, but required for fuzzy finder support
    dependencies = {
        'nvim-telescope/telescope-fzf-native.nvim'
    },
    config = function ()
        require("dropbar").setup {
            sources = {
                path = {
                    preview = false
                }
            }
        }

        local set_dropbar_colors = function()
            local hl_winbar = vim.api.nvim_get_hl(0, { name = "WinBar", link = false })
            local hl_winbar_nc = vim.api.nvim_get_hl(0, { name = "WinBarNC", link = false })
            local hl_normal = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
            vim.api.nvim_set_hl(0, "WinBar", { fg = hl_winbar.fg, bg = hl_normal.bg, bold = true })
            vim.api.nvim_set_hl(0, "WinBarNC", { fg = hl_winbar_nc.fg, bg = hl_normal.bg, bold = false })
        end
        vim.api.nvim_create_autocmd("ColorScheme", {
            pattern = "*",
            callback = set_dropbar_colors
        })
        vim.api.nvim_create_autocmd("OptionSet", {
            pattern = "background",
            callback = set_dropbar_colors
        })
    end
}
