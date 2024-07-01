return {
    "ray-x/lsp_signature.nvim",
    enabled = true,
    event = "VeryLazy",
    dependencies = { "neovim/nvim-lspconfig" },
    config = function ()
        require("lsp_signature").setup {
            bind = true,
            doc_lines = 30,
            max_height = 30,
            max_width = 120,
            floating_window_off_x = 0,
            floating_window_off_y = 0,
            handler_opts = {
                border = "none",
                focusable = false,
            },
            -- transparency = 20,
            hint_enable = false,
            padding = " "
        }
    end
}
