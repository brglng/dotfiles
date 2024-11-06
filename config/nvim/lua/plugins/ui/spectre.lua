return {
    "nvim-pack/nvim-spectre",
    dependencies = {
        "nvim-lua/plenary.nvim"
    },
    cmd = "Spectre",
    opts = {
        open_cmd = "botright split new"
    },
    keys = {
        { "<Leader>ss", mode = "n", function() require("spectre").toggle() end, desc = "Toggle Search UI" },
        { "<Leader>sw", mode = "n", function() require("spectre").open_visual({ select_word = true }) end, desc = "Search Cursor Word" },
        { "<Leader>sw", mode = "v", function() require("spectre").open_visual() end, desc = "Search Cursor Word" },
    }
}
