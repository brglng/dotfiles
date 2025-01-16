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
        dashboard_mode = false,
        last_session_on_startup = false
    },
    config = function(_, opts)
        local private_projects = vim.fn.expand("~/Syncthing/vps/dotfiles/config/nvim/lua/brglng/private_projects.lua")
        local local_projects = vim.fn.stdpath("data") .. "/neovim-project/projects.lua"
        if vim.uv.fs_open(private_projects, "r", 438) then
            vim.list_extend(opts.projects, dofile(private_projects))
        end
        if vim.uv.fs_open(local_projects, "r", 438) then
            vim.list_extend(opts.projects, dofile(local_projects))
        end
        vim.api.nvim_create_user_command("EditPrivateProjects", function()
            vim.cmd("edit " .. private_projects)
        end, { nargs = 0 })
        vim.api.nvim_create_user_command("EditLocalProjects", function()
            vim.cmd("edit " .. local_projects)
        end, { nargs = 0 })
        require("neovim-project").setup(opts)
    end,
    keys = {
        { "<Leader>fp", mode = "n", "<Cmd>NeovimProjectHistory<CR>", desc = "Recent Projects" },
        { "<Leader>fP", mode = "n", "<Cmd>NeovimProjectDiscover<CR>", desc = "All Projects" }
    },
}
