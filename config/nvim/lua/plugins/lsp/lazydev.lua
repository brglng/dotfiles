return {
    "folke/lazydev.nvim",
    dependencies = {
        { "Bilal2453/luvit-meta", lazy = true },
        { "justinsgithub/wezterm-types", lazy = true },
        { "LelouchHe/xmake-luals-addon", lazy = true },
    },
    ft = "lua", -- only load on lua files
    opts = {
        library = {
            "lazy.nvim",
            -- Load luvit types when the `vim.uv` word is found
            { path = "luvit-meta/library", words = { "vim%.uv" } },
            -- Load the wezterm types when the `wezterm` module is required
            { path = "wezterm-types", mods = { "wezterm" } },
            -- Load the xmake types when opening file named `xmake.lua`
            { path = "xmake-luals-addon/library", files = { "xmake.lua" } },
        },
    },
}
