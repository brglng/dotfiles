return {
    "coffebar/neovim-project",
    event = "VeryLazy",
    opts = {
        projects = { -- define project roots
            "~/Syncthing/vps/dotfiles",
            "~/Syncthing/sync/work/loostone/fdn_reverb",
            "~/Syncthing/sync/work/loostone/pm-audio-lib/*",
            "~/Syncthing/notes",
            "~/Syncthing/projects/*",
            "~/Syncthing/projects/vim-plugins/*",
            "~/Syncthing/bose/github/*",
            "/mnt/c/bose/github/*",
            "C:/bose/github/*"
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
        -- { "nvim-telescope/telescope.nvim" },
        { "Shatur/neovim-session-manager" },
    },
    lazy = false,
    priority = 100,
}
