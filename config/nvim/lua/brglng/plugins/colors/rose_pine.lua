return {
    "rose-pine/neovim",
    name = "rose-pine",
    cond = true,
    priority = 1000,
    opts = {
        enable = {
            terminal = true,
            legacy_highlights = false, -- Improve compatibility for previous versions of Neovim
            migrations = false, -- Handle deprecated options automatically
        }
    },
    config = function(_, opts)
        require("rose-pine").setup(opts)
        -- require("brglng.hl").transform_tbl {
        --     RenderMarkdownCode = { bg = { "emboss", from = "CursorLine.bg", amount = 0.04 } },
        --     RenderMarkdownCodeInline = { bg = { "emboss", from = "CursorLine.bg", amount = 0.04 } }
        -- }
    end
}
