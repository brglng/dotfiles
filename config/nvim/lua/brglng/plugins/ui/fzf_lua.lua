return {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-mini/mini.icons" },
    cond = false,
    lazy = false,
    opts = {},
    config = function(_, opts)
        require("fzf-lua").setup(opts)
    end,
    keys = {
        { "<Leader>b", mode = "n", function() require("fzf-lua").buffers() end, desc = "Buffers" },
        { "<Leader>fb", mode = "n", function() require("fzf-lua").buffers() end, desc = "Buffers" },
        { "<Leader>f;", mode = "n", function() require("fzf-lua").commands() end, desc = "Commands" },
        { "<Leader>ff", mode = "n", function() require("fzf-lua").files() end, desc = "Files" },
        { "<Leader>fg", mode = "n", function() require("fzf-lua").live_grep_native() end, desc = "Grep" },
        { "<Leader>fg", mode = "v", function() require("fzf-lua").grep_visual() end, desc = "Grep" },
        { "<Leader>fl", mode = "n", function() require("fzf-lua").blines() end, desc = "Current Buffer Lines" },
    }
}
