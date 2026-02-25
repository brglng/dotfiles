return {
    "3rd/image.nvim",
    enabled = true,
    cond = ((not vim.g.neovide) and vim.fn.has("win32") == 0),
    lazy = true,
    opts = {
        backend = "sixel", -- whatever backend you would like to use
        processor = "magick_cli",
        -- max_width = 100,
        -- max_height = 12,
        max_height_window_percentage = math.huge,
        max_width_window_percentage = math.huge,
        window_overlap_clear_enabled = true, -- toggles images when windows are overlapped
        window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
    }
}
