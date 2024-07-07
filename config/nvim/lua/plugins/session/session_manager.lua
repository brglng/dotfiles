return {
    "Shatur/neovim-session-manager",
    event = "VeryLazy",
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "s1n7ax/nvim-window-picker"
    },
    opts = {},
    -- config = function(_, opts)
    --     require("session_manager").setup(opts)
    --     local config = require("session_manager.config")
    --     require("session_manager").setup {
    --         autoload_mode = config.AutoloadMode.Disabled,
    --     }
    -- end
}
