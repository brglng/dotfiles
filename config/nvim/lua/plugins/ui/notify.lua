return {
    "rcarriga/nvim-notify",
    enabled = true,
    -- event = "VeryLazy",
    lazy = false,
    opts = {
        on_open = function(win)
            local win_border
            if vim.g.neovide then
                win_border = { ' ', ' ', ' ', ' ', '▁', '▁', '▁', ' ' }
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
                    { " " .. notif.icon, highlights.icon },
                }
            else
                win_title = {
                    { "─" .. notif.icon, highlights.icon },
                }
            end

            if type(title) == "string" and notif.duplicates then
                table.insert(win_title, { string.format("  %s x%d", title, #notif.duplicates), highlights.title })
            elseif type(title) == "string" and #title > 0 then
                table.insert(win_title, { " " .. title, highlights.title })
            end

            vim.api.nvim_buf_set_var(bufnr, "__notify_title__", win_title)

            local message = {}
            for _, msg in ipairs(notif.message) do
                table.insert(message, " " .. msg .. " ")
            end

            vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, message)

            vim.api.nvim_buf_set_extmark(bufnr, namespace, 0, 0, {
                hl_group = highlights.body,
                end_line = #message,
                priority = 50,
            })
        end
    },
    config = function(_, opts)
        local notify = require("notify")
        notify.setup(opts)
        local set_notify_colors = function()
            local colorutil = require('brglng.colorutil')
            local Normal = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
            local NormalFloat = vim.api.nvim_get_hl(0, { name = "NormalFloat", link = false })
            local FloatBorder = vim.api.nvim_get_hl(0, { name = "FloatBorder", link = false })
            local WinSeparator = vim.api.nvim_get_hl(0, { name = "WinSeparator", link = false })
            local DiagnosticInfo = vim.api.nvim_get_hl(0, { name = "DiagnosticInfo", link = false })
            local DiagnosticWarn = vim.api.nvim_get_hl(0, { name = "DiagnosticWarn", link = false })
            local DiagnosticError = vim.api.nvim_get_hl(0, { name = "DiagnosticError", link = false })
            if vim.g.neovide then
                vim.api.nvim_set_hl(0, "NotifyERRORIcon", {
                    fg = DiagnosticError.fg,
                    bg = NormalFloat.bg
                })
                vim.api.nvim_set_hl(0, "NotifyWARNIcon", {
                    fg = DiagnosticWarn.fg,
                    bg = NormalFloat.bg
                })
                vim.api.nvim_set_hl(0, "NotifyINFOIcon", {
                    fg = DiagnosticInfo.fg,
                    bg = NormalFloat.bg
                })
                vim.api.nvim_set_hl(0, "NotifyDEBUGIcon", {
                    fg = FloatBorder.fg,
                    bg = NormalFloat.bg
                })
                vim.api.nvim_set_hl(0, "NotifyTRACEIcon", {
                    fg = FloatBorder.fg,
                    bg = NormalFloat.bg
                })
                vim.api.nvim_set_hl(0, "NotifyERRORTitle", {
                    fg = DiagnosticError.fg,
                    bg = NormalFloat.bg
                })
                vim.api.nvim_set_hl(0, "NotifyWARNTitle", {
                    fg = DiagnosticWarn.fg,
                    bg = NormalFloat.bg
                })
                vim.api.nvim_set_hl(0, "NotifyINFOTitle", {
                    fg = DiagnosticInfo.fg,
                    bg = NormalFloat.bg
                })
                vim.api.nvim_set_hl(0, "NotifyDEBUGTitle", {
                    fg = FloatBorder.fg,
                    bg = NormalFloat.bg
                })
                vim.api.nvim_set_hl(0, "NotifyTRACETitle", {
                    fg = FloatBorder.fg,
                    bg = NormalFloat.bg
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

        -- Utility functions shared between progress reports for LSP and DAP

        local client_notifs = {}
        local function get_notif_data(client_id, token)
            if not client_notifs[client_id] then
                client_notifs[client_id] = {}
            end
            if not client_notifs[client_id][token] then
                client_notifs[client_id][token] = {}
            end
            return client_notifs[client_id][token]
        end

        local function format_message(title, message, percentage)
            if title ~= nil and #title > 0 then
                return title .. ": " .. (percentage and percentage .. "%\t" or "") .. (message or "")
            else
                return (percentage and percentage .. "%\t" or "") .. (message or "")
            end
        end

        -- LSP integration

        vim.lsp.handlers["$/progress"] = function(_, result, ctx)
            local client_id = ctx.client_id

            local val = result.value

            if not val.kind then
                return
            end

            local client_name = vim.lsp.get_client_by_id(client_id).name
            local notif_data = get_notif_data(client_id, result.token)

            if val.kind == "begin" then
                notif_data.title = val.title
                notif_data = get_notif_data(client_id, result.token)
                notif_data.notification = vim.notify(format_message(val.title, val.message, val.percentage), vim.log.levels.INFO, {
                    title = client_name,
                    timeout = false,
                    hide_from_history = true,
                })
                notif_data.last_update_time = vim.loop.now()
            elseif val.kind == "report" then
                if vim.uv.now() - notif_data.last_update_time > 100 then
                    notif_data.notification = vim.notify(format_message(val.title or notif_data.title, val.message, val.percentage), vim.log.levels.INFO, {
                        title = client_name,
                        replace = notif_data.notification,
                        timeout = false,
                        hide_from_history = true,
                    })
                    notif_data.last_update_time = vim.uv.now()
                end
            elseif val.kind == "end" then
                vim.notify(format_message(val.title or notif_data.title, val.message or "✔"), vim.log.levels.INFO, {
                    title = client_name,
                    replace = notif_data.notification,
                    timeout = 3000,
                    hide_from_history = false,
                })
            end
        end

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
