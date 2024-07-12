return {
    'sindrets/diffview.nvim',
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
    }
}
