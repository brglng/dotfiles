return {
    "noearc/jieba.nvim",
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    ft = { "markdown", "tex", "vimwiki", "txt", "norg" },
    cond = function()
        return vim.tbl_contains({ "markdown", "tex", "vimwiki", "txt", "norg" }, vim.o.filetype)
    end,
    dependencies = {
        "noearc/jieba-lua",
    },
    opts = {},
    keys = {
        { "b", mode = { "x", "n" }, function() require("jieba_nvim").wordmotion_b() end },
        { "B", mode = { "x", "n" }, function() require("jieba_nvim").wordmotion_B() end },
        { "w", mode = { "x", "n" }, function() require("jieba_nvim").wordmotion_w() end },
        { "W", mode = { "x", "n" }, function() require("jieba_nvim").wordmotion_W() end },
        { "e", mode = { "x", "n" }, function() require("jieba_nvim").wordmotion_e() end },
        { "E", mode = { "x", "n" }, function() require("jieba_nvim").wordmotion_E() end },
        { "ge", mode = { "x", "n" }, function() require("jieba_nvim").wordmotion_ge() end },
        { "gE", mode = { "x", "n" }, function() require("jieba_nvim").wordmotion_gE() end },
        { "cw", mode = { "n" }, function() require("jieba_nvim").change_w() end },
        { "dw", mode = { "n" }, function() require("jieba_nvim").delete_w() end },
        { "ce", mode = { "n" }, function() require("jieba_nvim").change_w() end },
        { "de", mode = { "n" }, function() require("jieba_nvim").delete_w() end },
    }
}
