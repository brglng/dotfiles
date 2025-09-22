return {
    "RRethy/vim-illuminate",
    enabled = true,
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    opts = {
        filetypes_denylist = {
            "neo-tree",
            "TelescopePrompt",
            "qf",
            "trouble",
            "toggleterm",
            "terminal",
            "norg",
        }
    },
    config = function(_, opts)
        local brglng = require("brglng")
        brglng.hl.transform_tbl {
            IlluminatedWordText = { fg = nil, bg = { "middle", from = { "CursorLine.bg", "Visual.bg" } } },
            IlluminatedWordRead = { fg = nil, bg = { "middle", from = { "CursorLine.bg", "Visual.bg" } } },
            IlluminatedWordWrite = { fg = nil, bg = { "middle", from = { "CursorLine.bg", "Visual.bg" } } },
        }
    end
}
