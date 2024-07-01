return {
    "mfussenegger/nvim-dap",
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
    end,
    keys = {
        { "<F6>", mode = "n", function() require("dap").terminate() end, desc = "Terminate" },
        { "<F9>", mode = "n", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
        { "<F10>", mode = "n", function() require("dap").step_over() end, desc = "Step Over" },
        { "<F11>", mode = "n", function() require("dap").step_into() end, desc = "Step Into" },
        { "<F12>", mode = "n", function() require("dap").step_out() end, desc = "Step Out" }
    }
}
