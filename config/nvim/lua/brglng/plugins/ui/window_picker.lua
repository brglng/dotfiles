return {
    "s1n7ax/nvim-window-picker",
    event = 'VeryLazy',
    version = '2.*',
    opts = {
        hint = "floating-big-letter",
        show_prompt = false,
        filter_rules = {
            autoselect_one = true,
            include_current_win = false,
            bo = {
                filetype = {
                    -- 'neo-tree',
                    "neo-tree-popup",
                    "notify"
                },
                buftype = {
                    -- 'terminal',
                    -- "quickfix"
                },
            },
        }
    },
    keys = {
        {
            "<leader>w",
            mode = "n",
            function()
                local win = require("window-picker").pick_window({
                })
                if win then
                    vim.api.nvim_set_current_win(win)
                end
            end,
            desc = "Pick Window",
        },
    },
}
