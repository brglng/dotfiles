return {
    "luckasRanarison/clear-action.nvim",
    event = 'VeryLazy',
    opts = {
        popup = {
            highlights = {
                title = 'NormalFloat'
            }
        },
        mappings = {
            code_action = {
                key = '<Leader>ca',
                mode = { 'n' },
                options = {
                    desc = 'Code Actions'
                }
            }
        }
    }
}
