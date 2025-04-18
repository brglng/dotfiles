return {
    "coffebar/neovim-project",
    lazy = false,
    priority = 100,
    event = "VeryLazy",
    dependencies = {
        { "nvim-lua/plenary.nvim" },
        -- { "nvim-telescope/telescope.nvim" },
        { "Shatur/neovim-session-manager" },
    },
    init = function()
        -- enable saving the state of plugins in the session
        -- vim.opt.sessionoptions:append("globals") -- save global variables that start with an uppercase letter and contain at least one lowercase letter.
    end,
    opts = {
        projects = { -- define project roots
            "~/Syncthing/vps/dotfiles",
            "~/Syncthing/notes",
            "~/Syncthing/projects/*",
            "~/Syncthing/projects/vim-plugins/*",
        },
        follow_symlinks = "partial",
        dashboard_mode = false,
        last_session_on_startup = false
    },
    config = function(_, opts)
        local my_projects = vim.fn.stdpath('config') .. "/lua/my/projects.lua"
        local local_projects = vim.fn.stdpath("data") .. "/neovim-project/projects.lua"
        if vim.uv.fs_open(my_projects, "r", 438) then
            vim.list_extend(opts.projects, dofile(my_projects))
        end
        if vim.uv.fs_open(local_projects, "r", 438) then
            vim.list_extend(opts.projects, dofile(local_projects))
        end
        vim.api.nvim_create_user_command("MyProjects", function()
            vim.cmd("edit " .. my_projects)
        end, { nargs = 0 })
        vim.api.nvim_create_user_command("MyLocalProjects", function()
            vim.cmd("edit " .. local_projects)
        end, { nargs = 0 })
        require("neovim-project").setup(opts)
    end,
    keys = {
        -- { "<Leader>fp", mode = "n", "<Cmd>NeovimProjectHistory<CR>", desc = "Recent Projects" },
        { "<Leader>fp", mode = "n", "<Cmd>NeovimProjectDiscover<CR>", desc = "All Projects" }
    },
}
