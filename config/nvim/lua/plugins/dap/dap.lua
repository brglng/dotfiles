return {
    {
        "mfussenegger/nvim-dap",
        event = { "BufReadPost", "BufWritePost", "BufNewFile" },
        dependencies = {
            "williamboman/mason.nvim",
            "theHamsta/nvim-dap-virtual-text",
        },
        config = function ()
            local dap = require("dap")

            dap.adapters.codelldb = {
                type = "server",
                port = "${port}",
                executable = {
                    command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
                    args = {"--port", "${port}"},
                }
            }

            dap.adapters.cppdbg = {
                id = "cppdbg",
                type = "executable",
                command = vim.fn.stdpath("data") .. "/mason/bin/OpenDebugAD7"
            }

            dap.configurations.cpp = {
                {
                    name = "Launch (GDB)",
                    type = "cppdbg",
                    request = "launch",
                    program = function()
                        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
                    end,
                    cwd = function()
                        return vim.fn.input('Working directory: ', vim.fn.getcwd() .. '/', 'dir')
                    end,
                },
                {
                    name = 'Attach to gdbserver :1234',
                    type = 'cppdbg',
                    request = 'launch',
                    MIMode = 'gdb',
                    miDebuggerServerAddress = 'localhost:1234',
                    miDebuggerPath = '/usr/bin/gdb',
                    program = function()
                        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
                    end,
                    cwd = function()
                        return vim.fn.input('Working directory: ', vim.fn.getcwd() .. '/', 'dir')
                    end,
                },
                {
                    name = "Launch (LLDB)",
                    type = "codelldb",
                    request = "launch",
                    program = function()
                        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
                    end,
                    cwd = function()
                        return vim.fn.input('Working directory: ', vim.fn.getcwd() .. '/', 'dir')
                    end,
                },
            }

            dap.configurations.c = dap.configurations.cpp
            dap.configurations.rust = dap.configurations.cpp

            vim.fn.sign_define('DapBreakpoint', {
                text = '',
                texthl = "DiagnosticSignError",
                numhl = "DiagnosticSignError"
            })
            vim.fn.sign_define('DapBreakpointCondition', {
                text = '',
                texthl = "DiagnosticSignError",
                numhl = "DiagnosticSignError"
            })
            vim.fn.sign_define('DapBreakpointRejected', {
                text = '',
                texthl = "DiagnosticSignError",
                numhl = "DiagnosticSignError"
            })
            vim.fn.sign_define('DapLogPoint', {
                text = '',
                texthl = "DiagnosticSignInfo",
                numhl = "DiagnosticSignInfo"
            })
            vim.fn.sign_define('DapStopped', {
                text = '',
                linehl = "CursorLine",
                texthl = "Search",
                numhl = "Search"
            })

            vim.cmd [[ autocmd FileType,BufNewFile,BufRead,BufEnter * if match(&filetype, '^dapui') >= 0 | setlocal nofoldenable foldcolumn=0 | endif ]]
            vim.cmd [[ autocmd FileType dap-float nnoremap <buffer> <silent> q <C-w>q ]]

            -- DAP integration with nvim-notify

            local client_notifs = {}

            local function get_notif_data(progress_id)
                if not client_notifs[progress_id] then
                    client_notifs[progress_id] = {}
                end
                return client_notifs[progress_id]
            end

            local function format_message(message, percentage)
                return (percentage and percentage .. "%\t" or "") .. (message or "")
            end

            dap.listeners.before['event_progressStart']['progress-notifications'] = function(session, body)
                local notif_data = get_notif_data(body.progressId)
                local message = format_message(body.message, body.percentage)
                notif_data.notification = vim.notify(message, vim.log.levels.INFO, {
                    title = session.config.type,
                    timeout = false,
                    hide_from_history = true,
                })
                notif_data.last_update_time = vim.loop.now()
            end

            dap.listeners.before['event_progressUpdate']['progress-notifications'] = function(session, body)
                local notif_data = get_notif_data(body.progressId)
                if vim.uv.now() - notif_data.last_update_time > 100 then
                    notif_data.notification = vim.notify(format_message(body.message, body.percentage), vim.log.levels.INFO, {
                        title = session.config.type,
                        replace = notif_data.notification,
                        hide_from_history = true,
                    })
                    notif_data.last_update_time = vim.uv.now()
                end
            end

            dap.listeners.before['event_progressEnd']['progress-notifications'] = function(session, body)
                local notif_data = get_notif_data(body.progressId)
                vim.notify(format_message(body.message or "✔"), vim.log.levels.INFO, {
                    title = session.config.type,
                    replace = notif_data.notification,
                    timeout = 5000,
                    hide_from_history = false,
                })
                client_notifs[body.progressId] = nil
            end
        end,
        keys = {
            { "<F6>", mode = "n", function() require("dap").terminate() end, desc = "Terminate" },
            { "<F9>", mode = "n", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
            { "<F10>", mode = "n", function() require("dap").step_over() end, desc = "Step Over" },
            { "<F11>", mode = "n", function() require("dap").step_into() end, desc = "Step Into" },
            { "<F12>", mode = "n", function() require("dap").step_out() end, desc = "Step Out" },
            { "<Leader>db", mode = "n", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
            { "<Leader>df", mode = "n", function() require("dap").step_out() end, desc = "Step Out" },
            { "<Leader>dn", mode = "n", function() require("dap").step_over() end, desc = "Step Over" },
            { "<Leader>ds", mode = "n", function() require("dap").step_into() end, desc = "Step Into" },
            { "<Leader>d[", mode = "n", function() require("dap").up() end, desc = "Frame Up" },
            { "<Leader>d]", mode = "n", function() require("dap").down() end, desc = "Frame Down" },
        }
    },
    {
        "jay-babu/mason-nvim-dap.nvim",
        event = { "BufReadPost", "BufWritePost", "BufNewFile" },
        dependencies = {
            "williamboman/mason.nvim",
            "mfussenegger/nvim-dap"
        },
        opts = {}
    },
}
