return {
    "folke/trouble.nvim",
    cmd = "Trouble",
    dependencies = {
        "echasnovski/mini.icons",
    },
    opts = {
        focus = true
    },
    keys = {
        { "<Leader>ld", "<Cmd>SidebarToggle trouble_lsp_definitions<CR>", mode = "n", desc = "Definitions" },
        { "<Leader>lD", "<Cmd>SidebarToggle trouble_lsp_declarations<CR>", mode = "n", desc = "Definitions" },
        { "<Leader>li", "<Cmd>SidebarToggle trouble_lsp_implementations<CR>", mode = "n", desc = "Implementations" },
        { "<Leader>lr", "<Cmd>SidebarToggle trouble_lsp_references<CR>", mode = "n", desc = "References" },
        { "<Leader>lt", "<Cmd>SidebarToggle trouble_lsp_type_definitions<CR>", mode = "n", desc = "Type Definitions" },
        { "<Leader>lc", desc = "Call Hierarchy" },
        { "<Leader>lci", "<Cmd>SidebarToggle trouble_incomping_calls<CR>", mode = "n", desc = "Incoming Calls" },
        { "<Leader>lco", "<Cmd>SidebarToggle trouble_outgoing_calls<CR>", mode = "n", desc = "Outgoing Calls" },
    }
}
