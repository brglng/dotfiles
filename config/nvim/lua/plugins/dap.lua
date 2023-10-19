local dap = require("dap")
require("dapui").setup()
require("nvim-dap-virtual-text").setup()

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

vim.fn.sign_define('DapBreakpoint', { text = '', numhl = "DiagnosticSignError" })
vim.fn.sign_define('DapBreakpointCondition', { text = 'ﳁ', numhl = "DiagnosticSignError" })
vim.fn.sign_define('DapBreakpointRejected', { text = '', numhl = "DiagnosticSignError" })
vim.fn.sign_define('DapLogPoint', { text = '', numhl = "DiagnosticSignInfo" })
vim.fn.sign_define('DapStopped', { text = '', linehl = "CursorLine", numhl = "Search" })
vim.keymap.set('n', '<F5>', function()
    require("dapui").open()
    require("dap").continue()
end)
vim.keymap.set('n', '<F6>', function() require("dap").terminate() end)
vim.keymap.set('n', '<F9>', function() require('dap').toggle_breakpoint() end)
vim.keymap.set('n', '<F10>', function() require('dap').step_over() end)
vim.keymap.set('n', '<F11>', function() require('dap').step_into() end)
vim.keymap.set('n', '<F12>', function() require('dap').step_out() end)
