return {
    "savq/melange-nvim",
    priority = 1000,
    config = function()
        local brglng = require("brglng")
        brglng.hl.transform_tbl(function(is_autocmd)
            if vim.g.colors_name == "melange" or not is_autocmd then
                return {
                    FloatBorder = {
                        -- fg = {
                        --     "blend",
                        --     fg = "FloatBorder.fg,NormalFloat.fg,Normal.fg",
                        --     bg = "NormalFloat.bg,Normal.bg",
                        --     opacity = 0.9
                        -- },
                        fg = "FloatBorder.fg",
                        bg = "NormalFloat.bg"
                    }
                }
            end
        end)
    end
}
