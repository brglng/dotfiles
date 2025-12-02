return {
    "benlubas/molten-nvim",
    version = "^1.0.0", -- use version <2.0.0 to avoid breaking changes
    dependencies = {
        "3rd/image.nvim",
        'willothy/wezterm.nvim',
    },
    build = ":UpdateRemotePlugins",
    init = function()
        -- these are examples, not defaults. Please see the readme
        if vim.g.neovide then
            vim.g.molten_auto_image_popup = true
        elseif vim.fn.has("win32") == 1 then
            vim.g.molten_image_provider = "wezterm"
            vim.g.molten_auto_open_output = false
        end
        vim.g.molten_output_win_max_height = 20
    end,
}
