return {
    "anAcc22/sakura.nvim",
    lazy = false,
    priority = 1000,
    config = function()
        local brglng = require("brglng")
        brglng.hl.transform_tbl(function(is_autocmd)
            if vim.g.colors_name == "sakura" or not is_autocmd then
                return {
                    Keyword = {
                        fg = "Keyword.fg",
                        bg = "Keyword.bg",
                        bold = true,
                    },
                    NeoTreeDirectoryIcon = {
                        fg = "Directory.fg",
                        bg = "Directory.bg",
                    },
                }
            end
        end)
    end
}
