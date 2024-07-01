return {
    "dstein64/nvim-scrollview",
    enabled = false,
    config = function ()
        require("scrollview").setup {
            winblend = 50,
            signs_on_startup = { "diagnostics", "conflicts", "cursor" },
            signs_column = 0,
            signs_max_per_row = 1,
            cursor_symbol = "•"
        }
        require("scrollview.contrib.gitsigns").setup()
    end
}
