return {
    "nvim-treesitter/nvim-treesitter-context",
    dependencies = "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    opts = {
        max_lines = "30%",
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
                TreesitterContext = { fg = nil, bg = nil },
                TreesitterContextSeparator = { fg = nil, bg = nil },
                TreesitterContextLineNumber = { link = "LineNr" },
            }
        end
    end,
}
