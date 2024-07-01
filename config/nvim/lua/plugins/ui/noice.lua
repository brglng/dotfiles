return {
    "folke/noice.nvim",
    enabled = true,
    event = "VeryLazy",
    dependencies = {
        "MunifTanjim/nui.nvim",
        "rcarriga/nvim-notify",
    },
    config = function ()
        local format = require("noice.lsp.format")
        local hacks = require("noice.util.hacks")

        require("noice").setup {
            messages = {
                view_search = false,
                view = "notify",
                view_error = "notify",
                view_warn = "notify",
            },
            popupmenu = {
                backend = "cmp",
            },
            notify = {
                view = "notify",
            },
            lsp = {
                progress = {
                    enabled = true,
                    view = "lsp_progress"
                },
                -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                    -- ["cmp.entry.get_documentation"] = true,
                },
                signature = {
                    enabled = false,
                },
                hover = {
                    enabled = true,
                }
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
                mini = {
                    -- border = "rounded",
                    position = {
                        row = -2
                    },
                    focusable = false,
                    win_options = {
                        -- winblend = 20,
                    }
                },
                cmdline_popup = {
                    position = {
                        row = "38%"
                    }
                },
                hover = {
                    border = {
                        -- style = "none",
                        -- padding = { 0, 2 }
                    },
                    win_options = {
                        -- winblend = 20,
                        winhighlight = {
                            FloatBorder = "Normal"
                        }
                    }
                },
                lsp_progress = {
                    backend = "notify",
                    fallback = "mini",
                    title = "LSP",
                    replace = true,
                    merge = true
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
                },
                {
                    filter = {
                        warning = true,
                        find = "heartbeat failed"
                    },
                    opts = { skip = true }
                }
            }
        }

        local function from_lsp_clangd(e)
            return vim.tbl_get(e, "source", "name") == "nvim_lsp"
            and vim.tbl_get(e, "source", "source", "client", "name") == "clangd"
        end

        hacks.on_module("cmp.entry", function(mod)
            mod.get_documentation = function(self)
                local item = self:get_completion_item()

                -- for k, v in pairs(item) do
                --     vim.notify(tostring(k) .. ": " .. tostring(v))
                -- end

                local lines = item.documentation and format.format_markdown(item.documentation) or {}
                local ret = table.concat(lines, "\n")
                local detail = item.detail
                if detail and type(detail) == "table" then
                    detail = table.concat(detail, "\n")
                end

                if from_lsp_clangd(self) then
                    detail = (tostring(item.label) or "")
                    if item.detail then
                        detail = tostring(item.detail) .. detail
                    end
                end

                if detail and not ret:find(detail, 1, true) then
                    local ft = self.context.filetype
                    local dot_index = string.find(ft, "%.")
                    if dot_index ~= nil then
                        ft = string.sub(ft, 0, dot_index - 1)
                    end
                    ret = ("```%s\n%s\n```\n%s"):format(ft, vim.trim(detail), ret)
                end
                return vim.split(ret, "\n")
            end
        end)
    end
}
