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
                        bold = true,
                    },
                    NeoTreeDirectoryIcon = {
                        fg = "Directory.fg",
                        bg = "Directory.bg",
                    },
                    IblIndent = {
                        fg = { "blend", fg = "ColorColumn.bg", bg = "Normal.bg", opacity = 0.7 },
                    },
                    ["@ibl.indent.char.1"] = {
                        fg = { "blend", fg = "ColorColumn.bg", bg = "Normal.bg", opacity = 0.7 },
                    }
                }
            end
        end)
    end
}
