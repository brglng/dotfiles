require('neo-tree').setup({
    enable_diagnostics = false,
    sources = {
        "filesystem",
        "buffers",
        "git_status",
        "document_symbols",
    },
    git_status = {
        added = "✚",
        modified = ""
    },
    filesystem = {
        bind_to_cwd = false,
        -- follow_current_file = {
        --     enabled = false,
        --     leave_dirs_open = true
        -- }
    },
    source_selector = {
        winbar = true,
        statusline = false,
        sources = {
            { source = "filesystem" },
            { source = "document_symbols" },
            { source = "buffers" },
            {
                source = "git_status",
                follow_cursor = true
            },
        },
    },
})
