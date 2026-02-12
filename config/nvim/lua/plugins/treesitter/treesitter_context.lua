return {
    "nvim-treesitter/nvim-treesitter-context",
    dependencies = "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    opts = {
        max_lines = 1,
        -- mode = 'topline',
        separator = (function ()
            if not vim.g.neovide then
                return '─'
            end
        end)(),
    },
    config = function(_, opts)
        require("treesitter-context").setup(opts)
        local brglng = require("brglng")
        if not vim.g.neovide then
            brglng.hl.transform_tbl {
                TreesitterContext = { fg = "Normal.fg", bg = "Normal.bg" },
                TreesitterContextSeparator = { fg = "WinSeparator.fg", bg = "Normal.bg" },
                TreesitterContextLineNumber = { link = "LineNr" },
            }
        end
    end,
}
