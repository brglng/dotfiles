require('neo-tree').setup({
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
        follow_current_file = {
            enabled = true,
            leave_dirs_open = true
        }
    },
    source_selector = {
        winbar = true,
        statusline = false,
        sources = {
            { source = "filesystem" },
            { source = "document_symbols" },
            { source = "buffers" },
            { source = "git_status" },
        },
    },
})
