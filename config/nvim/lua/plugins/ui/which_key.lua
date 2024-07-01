return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
        vim.o.timeout = true
        vim.o.timeoutlen = 300
    end,
    config = function ()
        -- vim.cmd [[ highlight! link WhichKeyFloat Normal ]]
        -- local set_which_key_border_color = function()
        --     vim.cmd [[ execute 'highlight! WhichKeyBorder guifg=' . synIDattr(synIDtrans(hlID('WinSeparator')), 'fg') . ' guibg=' . synIDattr(synIDtrans(hlID('NormalFloat')), 'bg') ]]
        -- end
        -- set_which_key_border_color()
        -- vim.api.nvim_create_autocmd("ColorScheme", {
        --     pattern = "*",
        --     callback = set_which_key_border_color
        -- })
        -- vim.api.nvim_create_autocmd("OptionSet", {
        --     pattern = "background",
        --     callback = set_which_key_border_color
        -- })

        require("which-key").setup {
            window = {
                -- border = {"", "─" ,"", "", "", "", "", "" },
                -- border = {"", "▔" ,"", "", "", "", "", "" },
                margin = { 0, 0, 0, 0 },
                padding = { 1, 0, 1, 0 }
            },
            layout = {
                align = "center"
            }
        }
        require("which-key").register({
            b = { require("telescope.builtin").buffers, "Buffers" },
            c = {
                "+code",
                a = { "<Cmd>Lspsaga code_action<CR>", "Code Actions" },
                c = { "<Cmd>Lspsaga incoming_calls<CR>", "Callers" },
                C = { "<Cmd>Lspsaga outgoing_calls<CR>", "Callees" },
                d = { "<Cmd>Trouble lsp_definitions<CR>", "Definitions" },
                D = { "<Cmd>Lspsaga peek_definition<CR>", "Peek Definitions" },
                e = { vim.diagnostic.open_float, "Show Diagnostics" },
                f = { function() vim.lsp.buf.format { async = true } end, "Format" },
                h = { "<Cmd>Lspsaga hover_doc<CR>", "Hover Doc" },
                i = { "<Cmd>Trouble lsp_implementations<CR>", "Implementations" },
                n = { "<Cmd>Navbuddy<CR>", "Navigate" },
                o = { "<Cmd>Lspsaga<CR>", "Outline" },
                r = { "<Cmd>Trouble lsp_references<CR>", "References" },
                R = { "<Cmd>Lspsaga rename<CR>", "Rename" },
                t = { "<Cmd>Trouble lsp_type_definitions<CR>", "Type Definitions" }
            },
            d = {
                name = "+debug",
                b = { require("dap").toggle_breakpoint, "Toggle Breakpoint" },
                d = { require("brglng.dap_util").start_debugging, "Start Debugging" },
                f = { require("dap").step_out, "Step Out" },
                h = { require("dap.ui.widgets").hover, "Debug Hover" },
                n = { require("dap").step_over, "Step Over" },
                p = { require("dap.ui.widgets").preview, "Debug Preview" },
                q = {
                    function()
                        require("dap").terminate()
                        require("dapui").close()
                    end,
                    "Stop Debugging"
                },
                s = { require("dap").step_into, "Step Into" },
                ["["] = { require("dap").up, "Up Frame" },
                ["]"] = { require("dap").down, "Down Frame" },
            },
            f = {
                name = "+fuzzy",
                b = { require("telescope.builtin").buffers, "Buffers" },
                c = { require("telescope.builtin").commands, "Commands" },
                C = { require("telescope.builtin").colorscheme, "Colorschemes" },
                f = { require("telescope.builtin").find_files, "Files" },
                g = { require("telescope.builtin").live_grep, "Grep" },
                h = { require("telescope.builtin").help_tags, "Help Tags" },
                l = { require("telescope.builtin").current_buffer_fuzzy_find, "Lines" },
                m = { require("telescope.builtin").marks, "Marks" },
                M = { require("telescope.builtin").man_pages, "Man Pages" },
                o = { require("telescope.builtin").vim_options, "Vim Options" },
                s = { require("telescope.builtin").lsp_document_symbols, "LSP Document Symbols" },
                r = { require("telescope.builtin").resume, "Resume Previous Picker" }
            },
            g = {
                name = "+git",
                b = { "<Cmd>Neogit kind=split branch<CR>", "Branches" },
                c = { "<Cmd>Neogit kind=split commit<CR>", "Commit" },
                d = { "<Cmd>DiffviewOpen<CR>", "Diff" },
                g = { "<Cmd>Neogit<CR>", "Neogit" },
                l = { "<Cmd>Neogit kind=split log<CR>", "Log" },
                p = { "<Cmd>Neogit kind=split pull<CR>", "Pull" },
                P = { "<Cmd>Neogit kind=split push<CR>", "Push" },
                s = { "<Cmd>Neogit kind=split<CR>", "Neogit Split" },
                t = { "<Cmd>Neogit kind=split stash<CR>", "Stash" }
            },
            h = {
                name = "+hunk",
                s = { require("gitsigns").stage_hunk, "Stage Hunk" },
                r = { require("gitsigns").reset_hunk, "Reset Hunk" },
                u = { require("gitsigns").undo_stage_hunk, "Undo Stage Hunk" },
                S = { require("gitsigns").stage_buffer, "Stage Buffer" },
                R = { require("gitsigns").reset_buffer, "Reset Buffer" },
                p = { require("gitsigns").preview_hunk, "Preview Hunk" },
                b = { require("gitsigns").blame_line, "Blame Line" },
                B = { require("gitsigns").toggle_current_line_blame, "Toggle Blame for Current Line" },
                d = { require("gitsigns").toggle_deleted, "Toggle Deleted" }
            },
            i = {
                function()
                    require("ibl").setup_buffer(0, {
                        enabled = not require("ibl.config").get_config(0).enabled
                    })
                end,
                "Toggle Indent Lines"
            },
            p = {
                function()
                    require("nabla").toggle_virt {
                        autogen = true,
                        silent = true,
                        align_center = true
                    }
                end,
                "Toggle LaTeX Preview"
            },
            s = {
                name = "+search",
                s = { require("spectre").toggle, "Toggle Search UI" },
                w = { function() require("spectre").open_visual({ select_word = true }) end, "Search Current Word" },
                p = { function() require("spectre").open_file_search({ select_word = true }) end, "Search on Current File" }
            },
            t = { require('telescope').extensions.asynctasks.all, "Tasks" },
            w = {
                name = "+windows",
                t = { "<Cmd>TodoTrouble<CR>", "TODOs" }
            }
        }, {
            prefix = "<Leader>"
        })
        require("which-key").register({
            s = {
                name = "+search",
                w = { require("spectre").open_visual, "Search Current Word" }
            }
        }, {
            mode = "v",
            prefix = "<Leader>"
        })
    end
}
