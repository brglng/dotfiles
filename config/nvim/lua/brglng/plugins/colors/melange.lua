return {
    "savq/melange-nvim",
    priority = 1000,
    config = function()
        local brglng = require("brglng")
        brglng.hl.modify_colorscheme("melange", function()
            local tbl = {
                FloatBorder = {
                    fg = { "blend", fg = "Normal.fg", bg = "Normal.bg", opacity = 0.6 },
                    bg = "NormalFloat.bg,Normal.bg"
                },
                LspInlayHint = {
                    fg = "NonText.fg",
                    bg = { "blend", fg = "NonText.fg", bg = "Normal.bg", opacity = 0.1 }
                },
            }
            if not vim.g.neovide then
                tbl.PmenuThumb = {
                    bg = { "blend", fg = "Normal.fg", bg = "Normal.bg", opacity = 0.6 }
                }
            end
            return tbl
        end)
    end
}
