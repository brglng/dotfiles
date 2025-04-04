return {
    "folke/snacks.nvim",
    dependencies = {
        "echasnovski/mini.icons",
    },
    event = "VeryLazy",
    -- @type snacks.Config
    opts = {
        indent = {
            enabled = false,
            only_current = true,
            -- filter = function(buf)
            --     return vim.g.snacks_indent ~= false and vim.b[buf].snacks_indent ~= false and vim.bo[buf].buftype == "" and vim.bo[buf].filetype == "python"
            -- end,
        },
        image = {
            enabled = true,
        },
        input = {
            enabled = true
        },
        statuscolumn = {
            enabled = false,
            left = {
                -- "mark",
                "sign",
                "git",
                "fold"
            },
            folds = {
                open = true,
                git_hl = false, -- use Git Signs hl for fold icons
            },
            git = {
                -- patterns to match Git signs
                patterns = { "GitSign", "MiniDiffSign" },
            },
        },
    },
    keys = {
        -- {
        --     "<leader>i",
        --     function()
        --         if Snacks.indent.enabled then
        --             Snacks.indent.disable()
        --         else
        --             Snacks.indent.enable()
        --         end
        --     end,
        --     mode = "n",
        --     desc = "Toggle Indent Guides"
        -- },
        {
            "<Leader>wn",
            function()
                Snacks.notifier.show_history()
            end,
            mode = "n",
            desc = "Show Notification History"
        }
    }
}
