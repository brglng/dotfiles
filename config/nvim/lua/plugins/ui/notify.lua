return {
    "rcarriga/nvim-notify",
    enabled = true,
    cond = true,
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
        render = function(bufnr, notif, highlights, config)
            local base = require("notify.render.base")
            local namespace = base.namespace()
            local title = notif.title[1]

            local win_title = { { " " .. notif.icon .. " ", highlights.icon } }

            if type(title) == "string" and notif.duplicates then
                table.insert(win_title, { string.format(" %s x%d ", title, #notif.duplicates), highlights.title })
            elseif type(title) == "string" and #title > 0 then
                table.insert(win_title, { title .. " ", highlights.title })
            end

            vim.api.nvim_buf_set_var(bufnr, "__notify_title__", win_title)

            local max_width = 0
            for _, line in ipairs(notif.message) do
                if vim.g.neovide then
                    max_width = math.max(max_width, vim.fn.strdisplaywidth(line, 2))
                else
                    max_width = math.max(max_width, vim.fn.strdisplaywidth(line, 1))
                end
            end
            max_width = math.max(max_width, 50)

            --- @type table<string>
            local message = {}
            for _, msg in ipairs(notif.message) do
                local m
                if vim.g.neovide then
                    m = "  " .. msg .. " "
                else
                    m = " " .. msg .. " "
                end
                while vim.fn.strdisplaywidth(m) < max_width do
                    m = m .. " "
                end
                table.insert(message, m)
            end

            vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, message)

            vim.api.nvim_buf_set_extmark(bufnr, namespace, 0, 0, {
                hl_group = highlights.body,
                end_row = #message,
                priority = 50,
            })
        end,
        -- fps = 15,
        top_down = false,
    },
    config = function(_, opts)
        local notify = require("notify")
        local brglng = require("brglng")

        notify.setup(opts)

        if vim.g.neovide then
            brglng.hl.transform_tbl {
                NotifyBackground = { fg = "NormalFloat.fg,Normal.fg", bg = "NormalFloat.bg,Normal.bg" },
                NotifyERRORIcon = { fg = "NormalFloat.bg,Normal.bg", bg = "DiagnosticError.fg" },
                NotifyWARNIcon = { fg = "NormalFloat.bg,Normal.bg", bg = "DiagnosticWarn.fg" },
                NotifyINFOIcon = { fg = "NormalFloat.bg,Normal.bg", bg = "FloatTitle.fg" },
                NotifyDEBUGIcon = { fg = "NormalFloat.bg,Normal.bg", bg = "FloatBorder.fg" },
                NotifyTRACEIcon = { fg = "NormalFloat.bg,Normal.bg", bg = "FloatBorder.fg", },
                NotifyERRORTitle = { fg = "NormalFloat.bg,Normal.bg", bg = "DiagnosticError.fg" },
                NotifyWARNTitle = { fg = "NormalFloat.bg,Normal.bg", bg = "DiagnosticWarn.fg" },
                NotifyINFOTitle = { fg = "NormalFloat.bg,Normal.bg", bg = "FloatTitle.fg" },
                NotifyDEBUGTitle = { fg = "NormalFloat.bg,Normal.bg", bg = "FloatBorder.fg" },
                NotifyTRACETitle = { fg = "DiagnosticInfo.bg", bg = "DiagnosticInfo.fg" },
                NotifyERRORBorder = { fg = "DiagnosticError.fg", bg = "NormalFloat.bg,Normal.bg" },
                NotifyWARNBorder = { fg = "DiagnosticWarn.fg", bg = "NormalFloat.bg,Normal.bg" },
                NotifyINFOBorder = { fg = "FloatTitle.fg", bg = "NormalFloat.bg,Normal.bg" },
                NotifyDEBUGBorder = { fg = "DiagnosticInfo.fg", bg = "NormalFloat.bg,Normal.bg" },
                NotifyTRACEBorder = { fg = "FloatBorder.fg", bg = "NormalFloat.bg,Normal.bg" },
                NotifyERRORBody = { fg = "NormalFloat.fg,Normal.fg", bg = "NormalFloat.bg,Normal.bg" },
                NotifyWARNBody = { fg = "NormalFloat.fg,Normal.fg", bg = "NormalFloat.bg,Normal.bg" },
                NotifyINFOBody = { fg = "NormalFloat.fg,Normal.fg", bg = "NormalFloat.bg,Normal.bg" },
                NotifyDEBUGBody = { fg = "NormalFloat.fg,Normal.fg", bg = "NormalFloat.bg,Normal.bg" },
                NotifyTRACEBody = { fg = "NormalFloat.fg,Normal.fg", bg = "NormalFloat.bg,Normal.bg" },
                NotifyProgressBar = { fg = "DiagnosticOk.fg", bg = "NormalFloat.bg,Normal.bg" },
            }
        else
            brglng.hl.transform_tbl {
                NotifyBackground = { fg = "Normal.fg", bg = "Normal.bg" },
                NotifyERRORIcon = { fg = "Normal.bg", bg = "DiagnosticError.fg" },
                NotifyWARNIcon = { fg = "Normal.bg", bg = "DiagnosticWarn.fg" },
                NotifyINFOIcon = { fg = "Normal.bg", bg = "FloatTitle.fg" },
                NotifyDEBUGIcon = { fg = "Normal.bg", bg = "FloatBorder.fg" },
                NotifyTRACEIcon = { fg = "Normal.bg", bg = "FloatBorder.fg" },
                NotifyERRORTitle = { fg = "Normal.bg", bg = "DiagnosticError.fg" },
                NotifyWARNTitle = { fg = "Normal.bg", bg = "DiagnosticWarn.fg" },
                NotifyINFOTitle = { fg = "Normal.bg", bg = "FloatTitle.fg" },
                NotifyDEBUGTitle = { fg = "Normal.bg", bg = "FloatBorder.fg" },
                NotifyTRACETitle = { fg = "Normal.bg", bg = "DiagnosticInfo.fg" },
                NotifyERRORBorder = { fg = "DiagnosticError.fg", bg = "Normal.bg" },
                NotifyWARNBorder = { fg = "DiagnosticWarn.fg", bg = "Normal.bg" },
                NotifyINFOBorder = { fg = "FloatTitle.fg", bg = "Normal.bg" },
                NotifyDEBUGBorder = { fg = "DiagnosticInfo.fg", bg = "Normal.bg" },
                NotifyTRACEBorder = { fg = "FloatBorder.fg", bg = "Normal.bg" },
                NotifyERRORBody = { fg = "Normal.fg", bg= "Normal.bg" },
                NotifyWARNBody = { fg = "Normal.fg", bg = "Normal.bg" },
                NotifyINFOBody = { fg = "Normal.fg", bg = "Normal.bg" },
                NotifyDEBUGBody = { fg = "Normal.fg", bg = "Normal.bg" },
                NotifyTRACEBody = { fg = "Normal.fg", bg = "Normal.bg" },
                NotifyProgressBar = { fg = "DiagnosticOk.fg", bg = "NormalFloat.bg,Normal.bg" },
            }
        end

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
            local notif_data = client_data.current_notif_data
            local msg_data
            if client_data.token_msg_data_tbl[token] then
                msg_data = client_data.token_msg_data_tbl[token]
            else
                msg_data = {
                    token = token,
                    title = nil,
                    msg = nil,
                    percentage_start = nil,
                    percentage_end = nil,
                    notif_data = notif_data,
                    notification = notif_data.notification,
                    last_update_time = vim.uv.now(),
                }
                table.insert(notif_data.msg_data_list, msg_data)
                client_data.token_msg_data_tbl[token] = msg_data
            end
            local tokens_to_remove = {}
            for t, data in pairs(client_data.token_msg_data_tbl) do
                if vim.uv.now() - data.last_update_time >= 5000 then
                    client_data.token_msg_data_tbl[t] = nil
                    table.insert(tokens_to_remove, t)
                end
            end
            local new_msg_data_list = {}
            for _, data in ipairs(notif_data.msg_data_list) do
                if not vim.list_contains(tokens_to_remove, data.token) and vim.uv.now() - data.last_update_time < 5000 then
                    table.insert(new_msg_data_list, data)
                end
            end
            notif_data.msg_data_list = new_msg_data_list
            return msg_data
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
            local percentage_start
            if vim.g.neovide then
                percentage_start = 2
            else
                percentage_start = 1
            end
            if title ~= nil and vim.fn.strdisplaywidth(title) > 0 then
                title = title .. " "
                percentage_start = vim.fn.strdisplaywidth(title) + percentage_start
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
            return title .. percentage .. message, percentage_start, percentage_start + #percentage
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
                    if vim.uv.now() - notif_data.last_update_time < 300 then
                        return
                    end
                    msg_data.msg, msg_data.percentage_start, msg_data.percentage_end = format_message(msg_data.title, val.message, val.percentage, false)
                elseif val.kind == "end" then
                    msg_data.msg, msg_data.percentage_start, msg_data.percentage_end = format_message(msg_data.title, val.message, val.percentage, true)
                    client_data.token_msg_data_tbl[params.token] = nil
                else
                    return
                end
                local msg = ""
                local row = 0
                for _, data in ipairs(notif_data.msg_data_list) do
                    if data.msg ~= "" then
                        if msg == "" then
                            msg = data.msg
                        else
                            msg = msg .. "\n" .. (data.msg or "")
                        end
                        data.row = row
                        row = row + 1
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
                        for _, data in ipairs(notif_data.msg_data_list) do
                            if data.percentage_end > data.percentage_start then
                                vim.api.nvim_buf_set_extmark(buf, namespace, data.row, data.percentage_start, {
                                    hl_group = "NotifyProgressBar",
                                    end_col = data.percentage_end,
                                    priority = 50,
                                })
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
