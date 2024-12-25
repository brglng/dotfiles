return {
    "luckasRanarison/clear-action.nvim",
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
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
    },
    config = function(_, opts)
        require("clear-action").setup(opts)

    end
}
