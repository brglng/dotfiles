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

        local brglng = require("brglng")
        brglng.hl.transform_tbl(function()
            -- if vim.g.colors_name == "sakura" then
                return {
                    IblIndent = {
                        fg = { "blend", fg = "ColorColumn.bg", bg = "Normal.bg", opacity = 1.0 },
                    },
                    ["@ibl.indent.char.1"] = {
                        fg = { "blend", fg = "ColorColumn.bg", bg = "Normal.bg", opacity = 1.0 },
                    }
                }
            -- end
        end)

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
