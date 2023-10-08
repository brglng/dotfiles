require("window-picker").setup({
    hint = "floating-big-letter",
    show_prompt = false,
    filter_rules = {
        autoselect_one = true,
        include_current_win = false,
        bo = {
            filetype = { 'neo-tree', "neo-tree-popup", "notify" },
            buftype = { 'terminal', "quickfix" },
        },
    }
})
