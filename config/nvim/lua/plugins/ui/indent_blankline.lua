return {
    "lukas-reineke/indent-blankline.nvim",
    enabled = true,
    -- event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    ft = { "make", "python", "yaml" },
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
    config = function(_, opts)
        require("ibl").setup(opts)
        vim.api.nvim_create_autocmd("Filetype", {
            pattern = "make,python,yaml",
            callback = function()
                require("ibl").setup_buffer(0, {
                    enabled = true
                })
            end
        })
    end,
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
