return {
    "nvim-pack/nvim-spectre",
    dependencies = {
        "nvim-lua/plenary.nvim"
    },
    cmd = "Spectre",
    opts = {
        open_cmd = "botright split new",
        live_update = false,
    },
    keys = {
        { "<Leader>ss", mode = "n", "<Cmd>SidebarToggle spectre<CR>", desc = "Toggle Search UI" },
        {
            "<Leader>sw",
            mode = "n",
            function()
                require("spectre").open_visual({ select_word = true })
                vim.fn.call("sidebar#close_side_except", { "bottom", "spectre" })
            end,
            desc = "Search Cursor Word"
        },
        {
            "<Leader>sw",
            mode = "v",
            function()
                require("spectre").open_visual()
                vim.fn.call("sidebar#close_side_except", { "bottom", "spectre" })
            end,
            desc = "Search Cursor Word"
        },
    }
}
