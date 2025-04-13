return {
    "kosayoda/nvim-lightbulb",
    event = "LspAttach",
    opts = {
        code_lenses = true,
        sign = {
            enabled = false,
        },
        virtual_text = {
            enabled = true
        },
        autocmd = {
            enabled = true,
            updatetime = -1,
            events = { "CursorHold", "CursorHoldI", "CursorMoved", "CursorMovedI" }
        },
        ignore = {
            ft = {
                "toggleterm",
                "neo-tree",
                "terminal"
            }
        }
    },
    config = function (_, opts)
        require("nvim-lightbulb").setup(opts)
        local function set_lightbulb_colors()
            -- local LightBulbVirtualText = vim.api.nvim_get_hl(0, { name = "LightBulbVirtualText", link = false })
            vim.api.nvim_set_hl(0, "LightBulbVirtualText", { bg = nil })
        end
        set_lightbulb_colors()
        vim.api.nvim_create_autocmd("ColorScheme", { pattern = "*", callback = set_lightbulb_colors })
        vim.api.nvim_create_autocmd("OptionSet", { pattern = "background", callback = set_lightbulb_colors })
    end
}
