return {
    "s1n7ax/nvim-window-picker",
    event = 'VeryLazy',
    lazy = true,
    version = '2.*',
    opts = {
        hint = "floating-big-letter",
        show_prompt = false,
        filter_rules = {
            autoselect_one = true,
            include_current_win = false,
            bo = {
                filetype = {
                    'neo-tree',
                    "neo-tree-popup",
                    "notify"
                },
                buftype = {
                    'terminal',
                    "quickfix"
                },
            },
        }
    }
}
