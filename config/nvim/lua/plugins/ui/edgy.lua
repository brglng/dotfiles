return {
    "folke/edgy.nvim",
    enabled = false,
    event = "VeryLazy",
    init = function()
        vim.opt.laststatus = 3
        vim.opt.splitkeep = "screen"
    end,
    opts = {
        animate = {
            enabled = true,
            -- fps = 200,
            cps = 120 * 6,
        },
        options = {
            left = { size = 40 },
            bottom = { size = 0.3 },
            right = { size = 0.4 }
        },
        left = {
            {
                ft = "neo-tree",
                title = "File Explorer",
                filter = function(buf, win)
                    return vim.b[buf].neo_tree_source == "filesystem"
                end,
                pinned = true,
            },
            {
                ft = "neo-tree",
                title = "Git",
                filter = function(buf, win)
                    return vim.b[buf].neo_tree_source == "git_status"
                end,
                pinned = true,
                collapsed = true,
                open = "Neotree position=right git_status"
            },
        },
        bottom = {
            {
                ft = "qf",
                title = "QuickFix",
                size = { height = 0.3 },
                filter = function(buf, win)
                    return vim.fn.getwininfo(win)[1].loclist == 0
                end
            },
            {
                ft = "qf",
                title = "Location List",
                size = { height = 0.3 },
                filter = function(buf, win)
                    return vim.fn.getwininfo(win)[1].loclist == 1
                end
            },
            {
                ft = "toggleterm",
                title = "Terminal",
                size = { height = 0.3 },
                filter = function(buf, win)
                    return vim.api.nvim_win_get_config(win).relative == ""
                end
            },
            {
                ft = "trouble",
                title = "Diagnostics",
                size = { height = 0.3 },
                filter = function(buf, win)
                    return require("trouble").inspect().opts.mode == "diagnostics"
                end
            },
            {
                ft = "trouble",
                title = "LSP Declarations",
                size = { height = 0.3 },
                filter = function(buf, win)
                    return require("trouble").inspect().opts.mode == "lsp_declarations"
                end
            },
            {
                ft = "trouble",
                title = "LSP Definitions",
                size = { height = 0.3 },
                filter = function(buf, win)
                    return require("trouble").inspect().opts.mode == "lsp_definitions"
                end
            },
            {
                ft = "trouble",
                title = "LSP Implementations",
                size = { height = 0.3 },
                filter = function(buf, win)
                    return require("trouble").inspect().opts.mode == "lsp_implementations"
                end
            },
            {
                ft = "trouble",
                title = "LSP Incoming Calls",
                size = { height = 0.3 },
                filter = function(buf, win)
                    return require("trouble").inspect().opts.mode == "lsp_incoming_calls"
                end
            },
            {
                ft = "trouble",
                title = "LSP Outgoing Calls",
                size = { height = 0.3 },
                filter = function(buf, win)
                    return require("trouble").inspect().opts.mode == "lsp_outgoing_calls"
                end
            },
            {
                ft = "trouble",
                title = "LSP References",
                size = { height = 0.3 },
                filter = function(buf, win)
                    return require("trouble").inspect().opts.mode == "lsp_references"
                end
            },
            {
                ft = "trouble",
                title = "LSP Type Definitions",
                size = { height = 0.3 },
                filter = function(buf, win)
                    return require("trouble").inspect().opts.mode == "lsp_type_definitions"
                end
            },
            {
                ft = "spectre_panel",
                title = "Spectre",
                size = { height = 0.3 }
            },
        },
        right = {
            {
                ft = "help",
                size = { width = 0.4 },
                filter = function(buf, win)
                    return vim.bo[buf].filetype == "help"
                end
            }
        }
    }
}
