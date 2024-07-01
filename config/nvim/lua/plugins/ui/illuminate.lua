return {
    "RRethy/vim-illuminate",
    config = function ()
        require('illuminate').configure {
            filetypes_denylist = {
                "neo-tree",
                "TelescopePrompt",
                "qf",
                "trouble",
                "toggleterm",
                "terminal",
                "norg",
            }
        }

        local set_illuminated_colors = function()
            vim.api.nvim_set_hl(0, "IlluminatedWordText", { link = "CursorLine" })
            vim.api.nvim_set_hl(0, "IlluminatedWordRead", { link = "CursorLine" })
            vim.api.nvim_set_hl(0, "IlluminatedWordWrite", { link = "CursorLine" })
        end
        vim.api.nvim_create_autocmd("ColorScheme", {
            pattern = "*",
            callback = set_illuminated_colors
        })
        vim.api.nvim_create_autocmd("OptionSet", {
            pattern = "background",
            callback = set_illuminated_colors
        })
    end
}
