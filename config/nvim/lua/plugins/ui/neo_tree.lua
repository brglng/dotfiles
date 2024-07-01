return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    cmd = "Neotree",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
        "MunifTanjim/nui.nvim",
        "s1n7ax/nvim-window-picker"
    },
    opts = {
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
            follow_current_file = {
                enabled = true,
                -- leave_dirs_open = true
            },
            use_libuv_file_watcher = true
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
    }
}
