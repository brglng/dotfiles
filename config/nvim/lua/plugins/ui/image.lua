return {
    "3rd/image.nvim",
    enabled = not vim.g.neovide,
    dependencies = {
        "vhyrro/luarocks.nvim"
    },
    lazy = true,
    opts = {
        backend = "kitty",
        integrations = {
            markdown = {
                enabled = true,
                clear_in_insert_mode = false,
                download_remote_images = true,
                only_render_image_at_cursor = false,
                filetypes = { "markdown", "vimwiki" },
            },
            neorg = {
                enabled = true,
                clear_in_insert_mode = false,
                download_remote_images = true,
                only_render_image_at_cursor = false,
                filetypes = { "norg" }
            },
        },
        editor_only_render_when_focused = false,
        tmux_show_only_in_active_window = true
    }
}
