return {
    "coffebar/neovim-project",
    lazy = false,
    priority = 100,
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
            "C:/bose/github/*",
            "C:/bose/svn/asd2/volvo_gpa/branches/*",
            "C:/bose/svn/asd2/volvo_gpa/branches/*/audio/simulink",
            "C:/bose/svn/asd2/volvo_gpa/branches/*/audio/simulink/application/model/code",
            "C:/bose/svn/asd2/volvo_gpa/tags/*",
            "C:/bose/svn/asd2/volvo_gpa/tags/*/audio/simulink",
            "C:/bose/svn/asd2/volvo_gpa/tags/*/audio/simulink/application/model/code",
            "C:/bose/svn/asd2/volvo_gpa/trunk",
            "C:/bose/svn/asd2/volvo_gpa/trunk/audio/simulink",
            "C:/bose/svn/asd2/volvo_gpa/trunk/audio/simulink/application/model/code",
            "C:/bose/AWE/mag7Control_module",
            "C:/DSP Concepts/AWE Designer * Pro/CustomModules/*"
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
    keys = {
        { "<Leader>fp", mode = "n", "<Cmd>NeovimProjectHistory<CR>", desc = "Recent Projects" },
        { "<Leader>fP", mode = "n", "<Cmd>NeovimProjectDiscover<CR>", desc = "All Projects" }
    },
}
