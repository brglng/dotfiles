return {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    main = "ibl",
    opts = {
        enabled = false,
        indent = {
            char = "▏",
            -- char = "│",
        },
        scope = {
            enabled = false
        },
        exclude = {
            filetypes = { "startify" }
        }
    },
    keys = {
        {
            "<Leader>i",
            mode = "n",
            function()
                require("ibl").setup_buffer(0, {
                    enabled = not require("ibl.config").get_config(0).enabled
                })
            end,
            desc = "Toggle Indent Lines"
        }
    }
}
