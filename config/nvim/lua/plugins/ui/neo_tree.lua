return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    cmd = { "Neotree" },
    dependencies = {
        "nvim-lua/plenary.nvim",
        "echasnovski/mini.icons", -- not strictly required, but recommended
        "MunifTanjim/nui.nvim",
        "s1n7ax/nvim-window-picker"
    },
    opts = {
        sources = {
            "filesystem",
            "buffers",
            "git_status",
            "document_symbols",
        },
        open_files_do_not_replace_types = { "terminal", "Trouble", "trouble", "qf", "Outline", "help", "spectre_panel", "undotree" },
        enable_diagnostics = false,
        buffers = {
            show_unloaded = true
        },
        filesystem = {
            bind_to_cwd = true,
            follow_current_file = {
                enabled = true,
                leave_dirs_open = true
            },
            use_libuv_file_watcher = true
        },
        document_symbols = {
            follow_cursor = true,
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
        default_component_configs = {
            -- indent = {
            --     with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
            --     expander_collapsed = "",
            --     expander_expanded = "",
            --     expander_highlight = "NeoTreeExpander",
            -- }
        },
        popup_border_style = (function()
            if vim.g.neovide then
                return "solid"
            else
                -- return { "▏", " ", " ", " ", " ", " ", "▏", "▏" }
                -- return { '🭽', '▔', '🭾', '▕', '🭿', '▁', '🭼', '▏' }
                -- return { '█', '█', '█', '▕', '🭿', '▁', '🭼', '▏' }
                return "rounded"
            end
        end)(),
    },
    config = function(_, opts)
        require('neo-tree').setup(opts)
        local brglng = require("brglng")
        brglng.hl.transform_tbl {
            NeoTreeTabActive = { fg = "Normal.fg", bg = "NeoTreeNormal.bg,Normal.bg" },
            NeoTreeTabInactive = { fg = "Comment.fg", bg = { "darken", from = "NeoTreeNormal.bg,Normal.bg", amount = 0.1 } },
            NeoTreeTabSeparatorActive = {
                fg = { "darken", from = "NeoTreeNormal.bg,Normal.bg", amount = 0.2 },
                bg = "NeoTreeNormal.bg,Normal.bg"
            },
            NeoTreeTabSeparatorInactive = {
                fg = { "darken", from = "NeoTreeNormal.bg,Normal.bg", amount = 0.2 },
                bg = { "darken", from = "NeoTreeNormal.bg,Normal.bg", amount = 0.1 }
            },
            NeoTreeWinSeparator = { link = "WinSeparator" },
            NeoTreeFloatBorder = { link = "FloatBorder" },
            NeoTreeFloatTitle = { fg = "FloatTitle.bg", bg = "FloatTitle.fg" },
        }
    end,
    keys = {
        { "<M-1>", "<Cmd>SidebarToggle neo_tree_filesystem<CR>", mode = { "n", "i", "t" }, desc = "File Tree" },
        { "<M-2>", "<Cmd>SidebarToggle neo_tree_document_symbols<CR>", mode = { "n", "i", "t" }, desc = "Symbols" },
        { "<M-3>", "<Cmd>SidebarToggle neo_tree_buffers<CR>", mode = { "n", "i", "t" }, desc = "Buffers" },
        { "<M-4>", "<Cmd>SidebarToggle neo_tree_git_status<CR>", mode = { "n", "i", "t" }, desc = "Git Status" },
    }
}
