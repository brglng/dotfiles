return {
    "ChuYanLon/telegram.nvim",
    build = "npm i",
    enabled = false,
    event = "VeryLazy",
    dependencies = {
        "MunifTanjim/nui.nvim",
        -- "folke/snacks.nvim",   -- optional: enables fuzzy-find chat picker
    },
    -- keys = {
        -- { "<leader>tt", "<cmd>Tg<Cr>", desc = "Toggle Telegram" },
        -- { "<leader>tL", "<cmd>TgLogout<Cr>", desc = "Logout Telegram" },
        -- { "<leader>tp", "<cmd>TgPr<Cr>", desc = "Create PR" },
        -- { "<leader>ti", "<cmd>TgIssue<Cr>", desc = "Manage Issues" },
    -- },
    cmd = {
        "Tg",
        "TgLogout",
        "TgPr",
        "TgIssue",
    },
    opts = {
        tdlib_path = vim.env.HOME .. "/.local/lib/libtdjson.dylib",
        proxy = "socks5://127.0.0.1:1086",
        http_port = 8081,
        ws_port = 8082
    },
}
