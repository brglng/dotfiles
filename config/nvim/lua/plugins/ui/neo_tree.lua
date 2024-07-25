return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    cmd = { "Neotree" },
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
        "MunifTanjim/nui.nvim",
        "s1n7ax/nvim-window-picker"
    },
    opts = {
        enable_diagnostics = false,
        sources = {
            "filesystem",
            "buffers",
            "git_status",
            "document_symbols",
        },
        git_status = {
            added = "✚",
            modified = ""
        },
        filesystem = {
            bind_to_cwd = false,
            follow_current_file = {
                enabled = true,
                -- leave_dirs_open = true
            },
            use_libuv_file_watcher = true
        },
        source_selector = {
            winbar = true,
            statusline = false,
            sources = {
                { source = "filesystem" },
                { source = "document_symbols" },
                { source = "buffers" },
                {
                    source = "git_status",
                    follow_cursor = true
                },
            },
        },
        -- popup_border_style = { " ", " ", " ", " ", " ", " " },
        popup_border_style = { '🭽', '▔', '🭾', '▕', '🭿', '▁', '🭼', '▏' },
        -- popup_border_style = { '█', '█', '█', '▕', '🭿', '▁', '🭼', '▏' },
        -- popup_border_style = "rounded"
    },
    config = function(_, opts)
        require('neo-tree').setup(opts)

        -- NeoTreeFloatBorder NeoTreeTitleBar
        local function set_neo_tree_colors()
            local colorutil = require('brglng.colorutil')
            local Normal = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
            local Comment = vim.api.nvim_get_hl(0, { name = "Comment", link = false })
            local NormalFloat = vim.api.nvim_get_hl(0, { name = "NormalFloat", link = false })
            local WinSeparator = vim.api.nvim_get_hl(0, { name = "WinSeparator", link = false })
            local NeoTreeNormal = vim.api.nvim_get_hl(0, { name = "NeoTreeNormal", link = false })
            local border_fg, bg
            if vim.o.background == 'dark' then
                border_fg = colorutil.reduce_value(Normal.bg, 0.1)
                bg = colorutil.add_value(NormalFloat.bg, 0.05)
            else
                border_fg = colorutil.transparency(WinSeparator.fg, NormalFloat.bg, 0.3)
                bg = colorutil.reduce_value(NormalFloat.bg, 0.05)
            end

            vim.api.nvim_set_hl(0, 'NeoTreeTabActive', {
                fg = NeoTreeNormal.fg,
                bg = NeoTreeNormal.bg
            })
            vim.api.nvim_set_hl(0, 'NeoTreeTabInactive', {
                fg = Comment.fg,
                bg = colorutil.reduce_value(NeoTreeNormal.bg, 0.1)
            })
            vim.api.nvim_set_hl(0, 'NeoTreeTabSeparatorActive', {
                fg = colorutil.reduce_value(NeoTreeNormal.bg, 0.2),
                bg = NeoTreeNormal.bg
            })
            vim.api.nvim_set_hl(0, 'NeoTreeTabSeparatorInactive', {
                fg = colorutil.reduce_value(NeoTreeNormal.bg, 0.2),
                bg = colorutil.reduce_value(NeoTreeNormal.bg, 0.1)
            })
            -- vim.api.nvim_set_hl(0, 'NeoTreeWinSeparator', { link = 'WinSeparator' })
            -- vim.api.nvim_set_hl(0, 'NeoTreeFloatNormal', { fg = NormalFloat.fg, bg = bg })
            -- vim.api.nvim_set_hl(0, 'NeoTreeFloatBorder', { fg = bg, bg = bg })
            vim.api.nvim_set_hl(0, 'NeoTreeFloatBorder', { fg = border_fg, bg = NormalFloat.bg })
            vim.api.nvim_set_hl(0, 'NeoTreeFloatTitle', { fg = NormalFloat.fg, bg = border_fg })
        end
        vim.api.nvim_create_autocmd("ColorScheme", {
            pattern = "*",
            callback = set_neo_tree_colors
        })
        vim.api.nvim_create_autocmd("OptionSet", {
            pattern = "background",
            callback = set_neo_tree_colors
        })
        -- vim.api.nvim_create_autocmd("FileType", {
        --     pattern = "neo-tree-popup",
        --     callback = set_neo_tree_colors
        -- })
        -- vim.api.nvim_create_autocmd("OptionSet", {
        --     pattern = "winhighlight",
        --     callback = function()
        --         if vim.o.filetype == 'neo-tree-popup' or vim.w.neo_tree_preview == 1 then
        --             vim.opt_local.winhighlight:append(',NormalFloat:NeoTreeFloatNormal')
        --         end
        --     end
        -- })
        set_neo_tree_colors()
    end
}
