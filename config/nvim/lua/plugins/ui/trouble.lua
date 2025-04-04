return {
    "folke/trouble.nvim",
    cmd = "Trouble",
    dependencies = {
        "echasnovski/mini.icons"
    },
    opts = {
        focus = true
    },
    keys = {
        { "<Leader>cd", "<Cmd>SidebarToggle trouble_lsp_definitions<CR>", mode = "n", desc = "Definitions" },
        { "<Leader>cD", "<Cmd>SidebarToggle trouble_lsp_declarations<CR>", mode = "n", desc = "Definitions" },
        { "<Leader>ci", "<Cmd>SidebarToggle trouble_lsp_implementations<CR>", mode = "n", desc = "Implementations" },
        { "<Leader>cr", "<Cmd>SidebarToggle trouble_lsp_references<CR>", mode = "n", desc = "References" },
        { "<Leader>ct", "<Cmd>SidebarToggle trouble_lsp_type_definitions<CR>", mode = "n", desc = "Type Definitions" },
        { "<Leader>cc", desc = "Call Hierarchy" },
        { "<Leader>cci", "<Cmd>SidebarToggle trouble_incomping_calls<CR>", mode = "n", desc = "Incoming Calls" },
        { "<Leader>cco", "<Cmd>SidebarToggle trouble_outgoing_calls<CR>", mode = "n", desc = "Outgoing Calls" },
    }
}
