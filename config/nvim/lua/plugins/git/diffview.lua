return {
    'sindrets/diffview.nvim',
    enabled = false,
    cmd = {
        'DiffviewFileHistory', 'DiffviewOpen', 'DiffviewToggleFiles', 'DiffviewFocusFiles', 'DiffviewRefresh'
    },
    opts = {
        enhanced_diff_hl = true,
        view = {
            merge_tool = {
                layout = "diff4_mixed",
            }
        }
    },
    keys = {
        { '<Leader>gd', '<Cmd>DiffviewOpen<CR>', desc = 'Diff' }
    }
}
