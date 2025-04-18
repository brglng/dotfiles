return {
    "savq/melange-nvim",
    priority = 1000,
    config = function()
        local brglng = require("brglng")
        brglng.hl.transform_tbl(function(is_autocmd)
            if is_autocmd and vim.g.colors_name ~= "melange" then
                return {}
            end
            return {
                FloatBorder = {
                    fg = {
                        "blend",
                        fg = "FloatBorder.fg,NormalFloat.fg,Normal.fg",
                        bg = "NormalFloat.bg,Normal.bg",
                        opacity = 0.5
                    },
                    bg = "NormalFloat.bg,Normal.bg"
                }
            }
        end)
    end
}
