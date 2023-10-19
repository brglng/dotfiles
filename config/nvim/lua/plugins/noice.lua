require("noice").setup {
    messages = {
        view_search = false
    },
    popupmenu = {
        backend = "cmp",
    },
    lsp = {
        progress = {
            enabled = true,
            view = "mini"
        },
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
        },
    },
    -- you can enable a preset for easier configuration
    presets = {
        bottom_search = false, -- use a classic bottom cmdline for search
        command_palette = true, -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false, -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = false, -- add a border to hover docs and signature help
    },
    views = {
        cmdline_popup = {
            position = {
                row = "38%"
            }
        }
    },
    routes = {
        {
            filter = {
                event = "msg_show",
                kind = "",
                find = "%d+ more line"
            },
            opts = { skip = true }
        },
        {
            filter = {
                event = "msg_show",
                kind = "",
                find = "%d+ 行被加入"
            },
            opts = { skip = true }
        },
        {
            filter = {
                event = "msg_show",
                kind = "",
                find = "多了 %d+ 行"
            },
            opts = { skip = true }
        },
        {
            filter = {
                event = "msg_show",
                kind = "",
                find = "少了 %d+ 行"
            },
            opts = { skip = true }
        },
        {
            filter = {
                event = "msg_show",
                kind = "",
                find = "%d+ line less"
            },
            opts = { skip = true }
        },
        {
            filter = {
                event = "msg_show",
                kind = "",
                find = "%d+ fewer lines"
            },
            opts = { skip = true }
        },
        {
            filter = {
                event = "msg_show",
                kind = "",
                find = "%d+ 行被去掉"
            },
            opts = { skip = true }
        },
        {
            filter = {
                event = "msg_show",
                kind = "",
                find = "%d+ change;"
            },
            opts = { skip = true }
        },
        {
            filter = {
                event = "msg_show",
                kind = "",
                find = "%d+ changes;"
            },
            opts = { skip = true }
        },
        {
            filter = {
                event = "msg_show",
                kind = "",
                find = "%d+ 行发生改变"
            },
            opts = { skip = true }
        },
        {
            filter = {
                event = "msg_show",
                kind = "",
                find = "缩进了 %d+ 行"
            },
            opts = { skip = true }
        },
        {
            filter = {
                event = "msg_show",
                kind = "",
                find = "%d+ lines indented"
            },
            opts = { skip = true }
        }
    }
}
