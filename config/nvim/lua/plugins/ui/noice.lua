return {
    "folke/noice.nvim",
    enabled = true,
    cond = true,
    dependencies = {
        "MunifTanjim/nui.nvim",
        "rcarriga/nvim-notify",
    },
    -- event = "VeryLazy",
    lazy = false,
    opts = {
        cmdline = {
            enabled = true,
        },
        messages = {
            enabled = true,
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
                enabled = false,
                view = "lsp_progress"
            },
            -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
            override = {
                ["vim.lsp.util.convert_input_to_markdown_lines"] = false,
                ["vim.lsp.util.stylize_markdown"] = false,
                ["cmp.entry.get_documentation"] = false,
            },
            hover = {
                enabled = false,
            },
            signature = {
                enabled = false,
            },
            message = {
                enabled = false,
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
                border = {
                    -- style = {' ', ' ', ' ', '▕', '🭿', '▁', ' ', ' ' },
                    -- style = {'🭽', '▔', '🭾', '▕', '🭿', '▁', '🭼', '▏' },
                    -- style = {' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' },
                    -- style = {' ', ' ', ' ', ' ', ' ', '▁', ' ', ' ' },
                    style = (function()
                        if vim.g.neovide then
                            return "solid"
                        else
                            return 'rounded'
                        end
                    end)(),
                },
                position = {
                    row = -2
                },
                focusable = false,
                win_options = {
                    -- winblend = 20,
                    -- winhighlight = 'NormalFloat:NormalFloat',
                }
            },
            cmdline_popup = {
                border = {
                    style = (function()
                        if vim.g.neovide then
                            return "solid"
                        else
                            return 'rounded'
                        end
                    end)(),
                    -- style = {'🭽', '▔', '🭾', '▕', '🭿', '▁', '🭼', '▏' },
                    -- style = {' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' },
                },
                position = {
                    row = "38%"
                },
                win_options = (function()
                    if vim.g.neovide then
                        return {
                            winhighlight = "NormalFloat:NormalFloat"
                        }
                    else
                        return {}
                    end
                end)()
            },
            hover = (function()
                if vim.g.neovide then
                    return {
                        border = {
                            style = "none",
                            -- style = { ' ', ' ', ' ', '▕', '🭿', '▁', ' ', ' ' },
                            -- style = { '🭽', '▔', '🭾', '▕', '🭿', '▁', '🭼', '▏' },
                            padding = {
                                top = 1,
                                bottom = 1,
                                left = 1,
                                right = 1,
                            }
                        },
                        position = {
                            row = 2,
                            col = 1
                        },
                        win_options = {
                            winhighlight = 'FloatBorder:NoiceHoverBorder'
                        }
                    }
                else
                    return {
                        border = {
                            style = "rounded"
                        },
                        win_options = {
                            winhighlight = 'NormalFloat:Normal'
                        }
                    }
                end
            end)(),
            lsp_progress = {
                backend = "notify",
                fallback = "mini",
                title = "LSP",
                replace = true,
                merge = true
            },
            split = {
                enter = true,
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
                    event = "msg_show",
                    kind = "",
                    find = "written"
                },
                opts = { skip = true }
            },
            {
                filter = {
                    event = "msg_show",
                    kind = "",
                    find = "已写入"
                },
                opts = { skip = true }
            },
            {
                filter = {
                    event = "msg_show",
                    kind = "",
                    find = "yanked"
                },
                opts = { skip = true }
            },
            {
                filter = {
                    event = "msg_show",
                    kind = "",
                    find = "<ed"
                },
                opts = { skip = true }
            },
            {
                filter = {
                    event = "msg_show",
                    kind = "",
                    find = ">ed"
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
    },
    config = function(_, opts)
        require("noice").setup(opts)

        local set_noice_color = function()
            local brglng = require("brglng")
            local Normal = vim.api.nvim_get_hl(0, { name = 'Normal', link = false })
            local NormalFloat = vim.api.nvim_get_hl(0, { name = 'NormalFloat', link = false })
            local FloatBorder = vim.api.nvim_get_hl(0, { name = 'FloatBorder', link = false })
            local DiagnosticSignInfo = vim.api.nvim_get_hl(0, { name = 'DiagnosticSignInfo', link = false })
            local DiagnosticSignWarn = vim.api.nvim_get_hl(0, { name = 'DiagnosticSignWarn', link = false })
            if vim.g.neovide then
                vim.api.nvim_set_hl(0, 'NoiceCmdlinePopup', {
                    fg = NormalFloat.fg,
                    bg = NormalFloat.bg
                })
                vim.api.nvim_set_hl(0, 'NoiceCmdlinePopupBorder', {
                    fg = NormalFloat.bg,
                    bg = NormalFloat.bg
                })
                vim.api.nvim_set_hl(0, 'NoiceCmdlinePopupBorderCmdline', {
                    fg = NormalFloat.bg,
                    bg = NormalFloat.bg
                })
                vim.api.nvim_set_hl(0, 'NoiceCmdlinePopupBorderSearch', {
                    fg = NormalFloat.bg,
                    bg = NormalFloat.bg
                })
                vim.api.nvim_set_hl(0, 'NoiceCmdlinePopupBorderLua', {
                    fg = NormalFloat.bg,
                    bg = NormalFloat.bg
                })
                vim.api.nvim_set_hl(0, 'NoiceCmdlinePopupBorderHelp', {
                    fg = NormalFloat.bg,
                    bg = NormalFloat.bg
                })
                vim.api.nvim_set_hl(0, 'NoiceCmdlinePopupBorderInput', {
                    fg = NormalFloat.bg,
                    bg = NormalFloat.bg
                })
                vim.api.nvim_set_hl(0, 'NoiceCmdlinePopupBorderFilter', {
                    fg = NormalFloat.bg,
                    bg = NormalFloat.bg
                })
                vim.api.nvim_set_hl(0, 'NoiceCmdlinePopupBorderCalculator', {
                    fg = NormalFloat.bg,
                    bg = NormalFloat.bg
                })
            end
            vim.api.nvim_set_hl(0, 'NoiceCmdlinePopupTitleCmdline', {
                fg = Normal.bg,
                bg = DiagnosticSignInfo.fg,
            })
            vim.api.nvim_set_hl(0, 'NoiceCmdlinePopupTitleSearch', {
                fg = Normal.bg,
                bg = DiagnosticSignWarn.fg,
            })
            vim.api.nvim_set_hl(0, 'NoiceCmdlinePopupTitleLua', {
                fg = Normal.bg,
                bg = DiagnosticSignInfo.fg,
            })
            vim.api.nvim_set_hl(0, 'NoiceCmdlinePopupTitleHelp', {
                fg = Normal.bg,
                bg = DiagnosticSignInfo.fg,
            })
            vim.api.nvim_set_hl(0, 'NoiceCmdlinePopupTitleInput', {
                fg = Normal.bg,
                bg = DiagnosticSignInfo.fg,
            })
            vim.api.nvim_set_hl(0, 'NoiceCmdlinePopupTitleFilter', {
                fg = Normal.bg,
                bg = DiagnosticSignInfo.fg,
            })
            vim.api.nvim_set_hl(0, 'NoiceCmdlinePopupTitleCalculator', {
                fg = Normal.bg,
                bg = DiagnosticSignInfo.fg,
            })
        end
        set_noice_color()
        vim.api.nvim_create_autocmd("ColorScheme", {
            pattern = "*",
            callback = set_noice_color
        })
        vim.api.nvim_create_autocmd("OptionSet", {
            pattern = "background",
            callback = set_noice_color
        })

        local format = require("noice.lsp.format")
        local hacks = require("noice.util.hacks")

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
