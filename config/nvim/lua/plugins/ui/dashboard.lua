return {
    'nvimdev/dashboard-nvim',
    enabled = false,
    lazy = false,
    dependencies = {
        { 'echasnovski/mini.icons' },
        {
            "rubiin/fortune.nvim",
            opts = {
                display_format = "long",
                content_type = "mixed"
            }
        }
    },
    opts = {
        theme = 'hyper',
        config = {
            header = {
                ' ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗',
                ' ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║',
                ' ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║',
                ' ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║',
                ' ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║',
                ' ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝',
                '',
                '',
            },
            packages = {
                enable = true
            },
            shortcut = {
                { desc = '󰊳 Update', group = '@property', action = 'Lazy update', key = 'u' },
                {
                    icon = ' ',
                    -- icon_hl = '@variable',
                    desc = 'New File',
                    -- group = 'Label',
                    action = 'enew',
                    key = 'e',
                },
                {
                    icon = ' ',
                    -- icon_hl = '@variable',
                    desc = 'Files',
                    group = 'Label',
                    action = 'Telescope find_files',
                    key = 'f',
                },
                {
                    icon = '󰙅 ',
                    desc = 'Projects',
                    action = 'Telescope neovim-project',
                    key = 'p',
                },
                {
                    icon = '󰔛 ',
                    desc = 'Plugin Profile',
                    action = 'Lazy profile',
                    key = 't',
                },
                {
                    icon = '󰿅 ',
                    desc = 'Quit',
                    action = 'q',
                    key = 'q',
                }
            },
            mru = { cwd_only = true },
            project = { action = 'Telescope neovim-project' },
            footer = function()
                local info = { "", "", "" }
                local fortune = require("fortune").get_fortune()
                info[4] = "  Neovim loaded " .. vim.fn.strftime("%H:%M") .. " on " .. vim.fn.strftime("%d/%m/%Y") .. " '"
                local footer = vim.list_extend(info, fortune)
                return footer
            end
        }
    },
}
