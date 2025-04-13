return {
    "rcarriga/nvim-notify",
    enabled = true,
    -- event = "VeryLazy",
    lazy = false,
    opts = {
        on_open = function(win)
            local win_border
            if vim.g.neovide then
                win_border = { '', ' ', '', '', '', '▁', '', '' }
            else
                -- return { '🭽', '▔', '🭾', '▕', '🭿', '▁', '🭼', '▏' }
                win_border = "rounded"
            end
            local buf, win_title
            buf = vim.api.nvim_win_get_buf(win)
            if buf > 0 then
                win_title = vim.api.nvim_buf_get_var(buf, "__notify_title__")
            end
            if win_title then
                vim.api.nvim_win_set_config(win, {
                    border = win_border,
                    focusable = false,
                    title = win_title,
                })
            else
                vim.api.nvim_win_set_config(win, {
                    border = win_border,
                    focusable = false,
                })
            end
        end,
        top_down = false,
        render = function(bufnr, notif, highlights, config)
            local base = require("notify.render.base")
            local namespace = base.namespace()
            local title = notif.title[1]

            local win_title
            if vim.g.neovide then
                win_title = {
                    { " " .. notif.icon .. " ", highlights.icon },
                }
            else
                win_title = {
                    { "╴" .. notif.icon .. " ", highlights.icon },
                }
            end

            if type(title) == "string" and notif.duplicates then
                if vim.g.neovide then
                    table.insert(win_title, { string.format(" %s x%d ", title, #notif.duplicates), highlights.title })
                else
                    table.insert(win_title, { string.format(" %s x%d╶", title, #notif.duplicates), highlights.title })
                end
            elseif type(title) == "string" and #title > 0 then
                if vim.g.neovide then
                    table.insert(win_title, { title .. " ", highlights.title })
                else
                    table.insert(win_title, { title .. "╶", highlights.title })
                end
            end

            vim.api.nvim_buf_set_var(bufnr, "__notify_title__", win_title)

            local message = {}
            for _, msg in ipairs(notif.message) do
                if vim.g.neovide then
                    table.insert(message, "  " .. msg .. " ")
                else
                    table.insert(message, " " .. msg .. " ")
                end
            end

            vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, message)

            vim.api.nvim_buf_set_extmark(bufnr, namespace, 0, 0, {
                hl_group = highlights.body,
                end_row = #message,
                priority = 50,
            })
        end
    },
    config = function(_, opts)
        local notify = require("notify")
        notify.setup(opts)
        local set_notify_colors = function()
            local Normal = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
            local NormalFloat = vim.api.nvim_get_hl(0, { name = "NormalFloat", link = false })
            local FloatBorder = vim.api.nvim_get_hl(0, { name = "FloatBorder", link = false })
            local WinSeparator = vim.api.nvim_get_hl(0, { name = "WinSeparator", link = false })
            local DiagnosticInfo = vim.api.nvim_get_hl(0, { name = "DiagnosticInfo", link = false })
            local DiagnosticWarn = vim.api.nvim_get_hl(0, { name = "DiagnosticWarn", link = false })
            local DiagnosticError = vim.api.nvim_get_hl(0, { name = "DiagnosticError", link = false })
            if vim.g.neovide then
                vim.api.nvim_set_hl(0, "NotifyERRORIcon", {
                    bg = DiagnosticError.fg,
                    fg = NormalFloat.bg
                })
                vim.api.nvim_set_hl(0, "NotifyWARNIcon", {
                    bg = DiagnosticWarn.fg,
                    fg = NormalFloat.bg
                })
                vim.api.nvim_set_hl(0, "NotifyINFOIcon", {
                    bg = DiagnosticInfo.fg,
                    fg = NormalFloat.bg
                })
                vim.api.nvim_set_hl(0, "NotifyDEBUGIcon", {
                    bg = FloatBorder.fg,
                    fg = NormalFloat.bg
                })
                vim.api.nvim_set_hl(0, "NotifyTRACEIcon", {
                    bg = FloatBorder.fg,
                    fg = NormalFloat.bg
                })
                vim.api.nvim_set_hl(0, "NotifyERRORTitle", {
                    bg = DiagnosticError.fg,
                    fg = NormalFloat.bg
                })
                vim.api.nvim_set_hl(0, "NotifyWARNTitle", {
                    bg = DiagnosticWarn.fg,
                    fg = NormalFloat.bg
                })
                vim.api.nvim_set_hl(0, "NotifyINFOTitle", {
                    bg = DiagnosticInfo.fg,
                    fg = NormalFloat.bg
                })
                vim.api.nvim_set_hl(0, "NotifyDEBUGTitle", {
                    bg = FloatBorder.fg,
                    fg = NormalFloat.bg
                })
                vim.api.nvim_set_hl(0, "NotifyTRACETitle", {
                    bg = FloatBorder.fg,
                    fg = NormalFloat.bg
                })
                vim.api.nvim_set_hl(0, "NotifyERRORBorder", {
                    fg = DiagnosticError.fg,
                    bg = NormalFloat.bg
                })
                vim.api.nvim_set_hl(0, "NotifyWARNBorder", {
                    fg = DiagnosticWarn.fg,
                    bg = NormalFloat.bg
                })
                vim.api.nvim_set_hl(0, "NotifyINFOBorder", {
                    fg = DiagnosticInfo.fg,
                    bg = NormalFloat.bg
                })
                vim.api.nvim_set_hl(0, "NotifyDEBUGBorder", {
                    fg = FloatBorder.fg,
                    bg = NormalFloat.bg
                })
                vim.api.nvim_set_hl(0, "NotifyTRACEBorder", {
                    fg = FloatBorder.fg,
                    bg = NormalFloat.bg
                })
                vim.api.nvim_set_hl(0, "NotifyERRORBody", {
                    fg = NormalFloat.fg,
                    bg = NormalFloat.bg
                })
                vim.api.nvim_set_hl(0, "NotifyWARNBody", {
                    fg = NormalFloat.fg,
                    bg = NormalFloat.bg
                })
                vim.api.nvim_set_hl(0, "NotifyINFOBody", {
                    fg = NormalFloat.fg,
                    bg = NormalFloat.bg
                })
                vim.api.nvim_set_hl(0, "NotifyDEBUGBody", {
                    fg = NormalFloat.fg,
                    bg = NormalFloat.bg
                })
                vim.api.nvim_set_hl(0, "NotifyTRACEBody", {
                    fg = NormalFloat.fg,
                    bg = NormalFloat.bg
                })
                vim.api.nvim_set_hl(0, "NotifyERRORBody", { link = "NormalFloat" })
                vim.api.nvim_set_hl(0, "NotifyWARNBody", { link = "NormalFloat" })
                vim.api.nvim_set_hl(0, "NotifyINFOBody", { link = "NormalFloat" })
                vim.api.nvim_set_hl(0, "NotifyDEBUGBody", { link = "NormalFloat" })
                vim.api.nvim_set_hl(0, "NotifyTRACEBody", { link = "NormalFloat" })
            else
                vim.api.nvim_set_hl(0, 'NotifyINFOIcon', { link = 'DiagnosticInfo' })
                vim.api.nvim_set_hl(0, 'NotifyINFOTitle', { link = 'DiagnosticInfo' })
                vim.api.nvim_set_hl(0, 'NotifyWARNIcon', { link = 'DiagnosticWarn' })
                vim.api.nvim_set_hl(0, 'NotifyWARNTitle', { link = 'DiagnosticWarn' })
                vim.api.nvim_set_hl(0, 'NotifyERRORIcon', { link = 'DiagnosticError' })
                vim.api.nvim_set_hl(0, 'NotifyERRORTitle', { link = 'DiagnosticError' })
                vim.api.nvim_set_hl(0, "NotifyERRORBorder", {
                    fg = DiagnosticError.fg,
                    bg = nil
                })
                vim.api.nvim_set_hl(0, "NotifyWARNBorder", {
                    fg = DiagnosticWarn.fg,
                    bg = nil
                })
                vim.api.nvim_set_hl(0, "NotifyINFOBorder", {
                    fg = DiagnosticInfo.fg,
                    bg = nil
                })
                vim.api.nvim_set_hl(0, "NotifyDEBUGBorder", {
                    fg = FloatBorder.fg,
                    bg = nil
                })
                vim.api.nvim_set_hl(0, "NotifyTRACEBorder", {
                    fg = FloatBorder.fg,
                    bg = nil
                })
                vim.api.nvim_set_hl(0, 'NotifyERRORBody', { link = 'Normal' })
                vim.api.nvim_set_hl(0, 'NotifyWARNBody', { link = 'Normal' })
                vim.api.nvim_set_hl(0, 'NotifyINFOBody', { link = 'Normal' })
                vim.api.nvim_set_hl(0, 'NotifyDEBUGBody', { link = 'Normal' })
                vim.api.nvim_set_hl(0, 'NotifyTRACEBody', { link = 'Normal' })
            end

        end
        set_notify_colors()
        vim.api.nvim_create_autocmd("ColorScheme", {
            pattern = "*",
            callback = set_notify_colors
        })
        vim.api.nvim_create_autocmd("OptionSet", {
            pattern = "background",
            callback = set_notify_colors
        })

        -- LSP Progress Notifications

        local client_tbl = {}

        local function get_client_data(client_id)
            if not client_tbl[client_id] then
                client_tbl[client_id] = {
                    current_notif_data = {
                        last_update_time = 0,
                        msg_data_list = {},
                        notification = nil
                    },
                    token_msg_data_tbl = {}
                }
            end
            return client_tbl[client_id]
        end

        local function get_msg_data(client_data, token)
            local notif_data
            if vim.uv.now() - client_data.current_notif_data.last_update_time < 2000 then
                notif_data = client_data.current_notif_data
            else
                notif_data = {
                    last_update_time = vim.uv.now(),
                    msg_data_list = {},
                    notification = nil
                }
                client_data.current_notif_data = notif_data
            end

            if client_data.token_msg_data_tbl[token] then
                return client_data.token_msg_data_tbl[token]
            else
                local msg_data = {
                    token = token,
                    title = nil,
                    msg = nil,
                    percentage_start = nil,
                    percentage_end = nil,
                    notif_data = notif_data,
                    notification = notif_data.notification
                }
                table.insert(notif_data.msg_data_list, msg_data)
                client_data.token_msg_data_tbl[token] = msg_data
                return msg_data
            end
        end

        local function draw_percentage(percentage, len)
            if not percentage then
                -- return vim.fn["repeat"]("░", len)
                -- return vim.fn["repeat"]("─", len)
                return ""
            end
            local left_count = math.floor(percentage / 100 * len)
            local half
            local right_count
            if percentage / 100 * len - left_count < 0.5 then
                half = ""
                right_count = len - left_count
            else
                half = "╸"
                right_count = len - left_count - 1
            end
            -- return vim.fn["repeat"]("█", count) .. vim.fn["repeat"]("░", len - count)
            -- return vim.fn["repeat"]("━", count) .. vim.fn["repeat"]("─", len - count)
            return vim.fn["repeat"]("━", left_count) .. half .. vim.fn["repeat"](" ", right_count)
        end

        local function format_message(title, message, percentage, is_end)
            if title ~= nil and #title > 0 then
                title = title .. " "
            else
                title = ""
            end
            if is_end then
                percentage = ""
                message = message or "✔"
            else
                percentage = draw_percentage(percentage, 20) .. " "
                message = message or ""
            end
            return title .. percentage .. message, #title + 1, #title + 1 + #percentage
        end

        vim.api.nvim_create_autocmd("LspProgress", {
            pattern = "*",
            callback = function (ev)
                local client_id = ev.data.client_id
                local params = ev.data.params
                local val = params.value
                if not val.kind then
                    return
                end
                local client_data = get_client_data(client_id)
                local msg_data = get_msg_data(client_data, params.token)
                local notif_data = msg_data.notif_data
                if val.title then
                    if #val.title >= 3 and val.title:sub(#val.title - 2, #val.title) == "..." then
                        val.title = val.title:sub(1, #val.title - 3)
                    end
                    msg_data.title = val.title
                end
                if val.kind == "begin" then
                    msg_data.msg, msg_data.percentage_start, msg_data.percentage_end = format_message(msg_data.title, val.message, val.percentage, false)
                elseif val.kind == "report" then
                    if vim.uv.now() - notif_data.last_update_time < 200 then
                        return
                    end
                    msg_data.msg, msg_data.percentage_start, msg_data.percentage_end = format_message(msg_data.title, val.message, val.percentage, false)
                elseif val.kind == "end" then
                    msg_data.msg, msg_data.percentage_start, msg_data.percentage_end = format_message(msg_data.title, val.message, val.percentage, true)
                    client_data.token_msg_data_tbl[params.token] = nil
                end
                local msg = ""
                for _, data in ipairs(notif_data.msg_data_list) do
                    if data.msg ~= "" then
                        if msg == "" then
                            msg = data.msg
                        else
                            msg = msg .. "\n" .. data.msg
                        end
                    end
                end
                notif_data.notification = vim.notify(msg, vim.log.levels.INFO, {
                    title = vim.lsp.get_client_by_id(client_id).name,
                    timeout = 5000,
                    replace = notif_data.notification,
                    hide_from_history = (val.kind == "report"),
                    render = function(buf, notif, highlights, config)
                        opts.render(buf, notif, highlights, config)
                        local base = require("notify.render.base")
                        local namespace = base.namespace()
                        local row = 0
                        for _, data in ipairs(notif_data.msg_data_list) do
                            if data.msg ~= "" then
                                vim.api.nvim_buf_set_extmark(buf, namespace, row, data.percentage_start, {
                                    hl_group = "DiagnosticInfo",
                                    end_col = data.percentage_end,
                                    priority = 50,
                                })
                                row = row + 1
                            end
                        end
                    end
                })
                notif_data.last_update_time = vim.uv.now()
            end
        })

        -- table from lsp severity to vim severity.
        local severity = {
            vim.log.levels.ERROR,
            vim.log.levels.WARN,
            vim.log.levels.INFO,
            vim.log.levels.INFO, -- map both hint and info to info?
        }
        vim.lsp.handlers["window/showMessage"] = function(err, method, params, client_id)
            notify(method.message, severity[params.type])
        end

    end
}
