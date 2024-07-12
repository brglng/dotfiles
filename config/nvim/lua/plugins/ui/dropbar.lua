return {
    'Bekaboo/dropbar.nvim',
    -- optional, but required for fuzzy finder support
    dependencies = {
        'nvim-telescope/telescope-fzf-native.nvim'
    },
    opts = {
        sources = {
            path = {
                preview = false
            }
        }
    },
    config = function (_, opts)
        require("dropbar").setup(opts)

        local set_dropbar_colors = function()
            local WinBar = vim.api.nvim_get_hl(0, { name = "WinBar", link = false })
            local WinBarNC = vim.api.nvim_get_hl(0, { name = "WinBarNC", link = false })
            local Normal = vim.api.nvim_get_hl(0, { name = 'Normal', link = false })
            vim.api.nvim_set_hl(0, "WinBar", { fg = WinBar.fg, bg = Normal.bg, bold = true })
            vim.api.nvim_set_hl(0, "WinBarNC", { fg = WinBarNC.fg, bg = Normal.bg, bold = false })
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
