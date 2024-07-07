return {
    "coffebar/neovim-project",
    opts = {
        projects = { -- define project roots
            "~/Syncthing/vps/dotfiles",
            "~/Syncthing/sync/work/loostone/fdn_reverb",
            "~/Syncthing/sync/work/loostone/pm-audio-lib/*",
            "~/Syncthing/sync/notes",
            "~/Syncthing/sync/Projects/*",
            "~/Syncthing/sync/Projects/vim-plugins/*",
        },
        dashboard_mode = false,
        last_session_on_startup = false
    },
    init = function()
        -- enable saving the state of plugins in the session
        -- vim.opt.sessionoptions:append("globals") -- save global variables that start with an uppercase letter and contain at least one lowercase letter.
    end,
    dependencies = {
        { "nvim-lua/plenary.nvim" },
        { "nvim-telescope/telescope.nvim", tag = "0.1.4" },
        { "Shatur/neovim-session-manager" },
    },
    lazy = false,
    priority = 100,
}
