vim.opt.mousemoveevent = false
vim.diagnostic.config {
    virtual_text = false,
}
local signs = { Error = " ", Warn = " ", Info = " ", Hint = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end
vim.cmd [[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]]

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup(
    {
        -- LSP, Treesitter, Snippet, Auto-Pairing, Snippets, Auto-Completion
        { "folke/neodev.nvim" },
        { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
        { "nvim-treesitter/nvim-treesitter-textobjects", dependencies = "nvim-treesitter/nvim-treesitter" },
        { "neovim/nvim-lspconfig" },
        { "williamboman/mason.nvim" },
        { "williamboman/mason-lspconfig.nvim", dependencies = { "neovim/nvim-lspconfig" } },
        { "mfussenegger/nvim-lint" },
        { "mhartington/formatter.nvim" },
        {
            "windwp/nvim-autopairs",
            event = "InsertEnter"
        },
        -- {
        --     'altermo/ultimate-autopair.nvim',
        --     event={'InsertEnter','CmdlineEnter'},
        --     branch='v0.6'
        -- },
        {
            "L3MON4D3/LuaSnip",
            dependencies = {
                "rafamadriz/friendly-snippets",
            }
        },
        {
            "hrsh7th/nvim-cmp",
            dependencies = {
                "neovim/nvim-lspconfig",
                "hrsh7th/cmp-nvim-lsp",
                "hrsh7th/cmp-buffer",
                "hrsh7th/cmp-nvim-lua",
                "hrsh7th/cmp-path",
                "hrsh7th/cmp-cmdline",
                "hrsh7th/cmp-omni",
                "L3MON4D3/LuaSnip",
                "saadparwaiz1/cmp_luasnip",
                "petertriho/cmp-git",
                "davidsierradz/cmp-conventionalcommits",
                "FelipeLema/cmp-async-path",
                "onsails/lspkind.nvim"
            }
        },
        {
            "nvimdev/lspsaga.nvim",
            dependencies = {
                'nvim-treesitter/nvim-treesitter',
                'nvim-tree/nvim-web-devicons'
            }
        },
        { "mfussenegger/nvim-dap" },
        { "rcarriga/nvim-dap-ui", dependencies = { "mfussenegger/nvim-dap" } },
        { "RRethy/vim-illuminate" },

        -- Project Management
        { "stevearc/overseer.nvim" },

        -- UI
        {
            "akinsho/bufferline.nvim",
            version = "*",
            dependencies = {
                "nvim-tree/nvim-web-devicons",
            }
        },
        { "lukas-reineke/indent-blankline.nvim" },
        {
            "folke/noice.nvim",
            event = "VeryLazy",
            dependencies = {
                "MunifTanjim/nui.nvim",
                "rcarriga/nvim-notify",
            }
        },
        {
            "s1n7ax/nvim-window-picker",
            name = 'window-picker',
            event = 'VeryLazy',
            version = '2.*',
        },
        {
            "nvim-neo-tree/neo-tree.nvim",
            branch = "v3.x",
            dependencies = {
                "nvim-lua/plenary.nvim",
                "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
                "MunifTanjim/nui.nvim",
                "s1n7ax/nvim-window-picker"
            }
        },
        { "SmiteshP/nvim-navic", dependencies = { "neovim/nvim-lspconfig" } },
        {
            "SmiteshP/nvim-navbuddy",
            dependencies = {
                "neovim/nvim-lspconfig",
                "SmiteshP/nvim-navic",
                "MunifTanjim/nui.nvim",
            }
        },
        {
            "nvim-lualine/lualine.nvim",
            dependencies = {
                "nvim-tree/nvim-web-devicons",
                "SmiteshP/nvim-navic",
                -- 'linrongbin16/lsp-progress.nvim',
            }
        },
        -- {
        --     'linrongbin16/lsp-progress.nvim',
        --     dependencies = { 'nvim-tree/nvim-web-devicons' },
        -- },
        -- {
        --     "utilyre/barbecue.nvim",
        --     name = "barbecue",
        --     version = "*",
        --     dependencies = {
        --         "SmiteshP/nvim-navic",
        --         "nvim-tree/nvim-web-devicons",
        --     }
        -- },
        -- {
        --     'Bekaboo/dropbar.nvim',
        --     -- optional, but required for fuzzy finder support
        --     dependencies = {
        --         'nvim-telescope/telescope-fzf-native'
        --     }
        -- },
        {
            "folke/trouble.nvim",
            dependencies = { "nvim-tree/nvim-web-devicons" },
            opts = {
                -- your configuration comes here
                -- or leave it empty to use the default settings
                -- refer to the configuration section below
            },
        },
        { 'akinsho/toggleterm.nvim', version = "*" },
        {
            "kevinhwang91/nvim-ufo",
            dependencies = {
                "kevinhwang91/promise-async",
                'nvim-treesitter/nvim-treesitter',
                "luukvbaal/statuscol.nvim"
            }
        },
        { "anuvyklack/fold-preview.nvim", dependencies = "anuvyklack/keymap-amend.nvim" },

        -- Source control
        {
            "NeogitOrg/neogit",
            dependencies = {
                'sindrets/diffview.nvim',
                "nvim-lua/plenary.nvim"
            }
        },
        {
            "lewis6991/gitsigns.nvim",
        },

        -- Editing and Motion
        {
            "folke/flash.nvim",
            keys = {
                { "s", mode = { "n", "o", "x" }, function() require("flash").jump() end, desc = "Flash" },
                -- { "S", mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
                { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
                { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
                { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" }
            }
        },
        {
            "folke/todo-comments.nvim",
            dependencies = { "nvim-lua/plenary.nvim" }
        },
        {
            "chrisgrieser/nvim-early-retirement",
            config = true,
            event = "VeryLazy",
        },
        {
            "iamcco/markdown-preview.nvim",
            build = ":call mkdp#util#install()"
        },
        {
            "kylechui/nvim-surround",
            version = "*",
            event = "VeryLazy",
        },

        -- Color schemes
        { "ellisonleao/gruvbox.nvim" },
        { "catppuccin/nvim", name = "catppuccin", config = true, priority = 1000 },
        { "folke/tokyonight.nvim", priority = 1000 },
    }, {
        lockfile = vim.fn.stdpath("data") .. "/lazy-lock.json",
        performance = {
            rtp = {
                reset = false
            }
        }
    }
)

require("plugins.neodev")
require("plugins.treesitter")
require("plugins.lsp")
require("plugins.lint")
require("plugins.formatter")
require("plugins.autopairs")
-- require("plugin_config.ultimate_autopair")
require("plugins.cmp")
require("plugins.lspsaga")
require("plugins.dap")
-- require("plugins.illuminate")

require("plugins.overseer")

require("plugins.bufferline")
require("plugins.indent_blankline")
require("plugins.window_picker")
require("plugins.neo_tree")
require("plugins.navic")
require("plugins.navbuddy")
-- require("plugin_config.barbecue")
require("plugins.lualine")
require("plugins.trouble")
require("plugins.notify")
require("plugins.noice")
require("plugins.toggleterm")
require("plugins.ufo")
require("plugins.statuscol")
require("plugins.fold_preview")

require("plugins.neogit")
require("plugins.gitsigns")
require("plugins.todo_comments")
require("plugins.surround")

require("plugins.gruvbox")
require("plugins.tokyonight")
