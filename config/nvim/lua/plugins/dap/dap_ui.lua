return {
    "rcarriga/nvim-dap-ui",
    dependencies = {
        "mfussenegger/nvim-dap",
        "nvim-neotest/nvim-nio"
    },
    opts = {},
    keys = {
        { "<F5>", mode = "n", function() require("brglng").dap.start_debugging() end, desc = "Continue" },
        { "<Leader>dc", mode = "n", function() require("brglng").dap.start_debugging() end, desc = "Continue" },
        { "<Leader>dd", mode = "n", function() require("dapui").toggle() end, desc = "Toggle Debug UI" },
        { "<Leader>dh", mode = "n", function() require("dap.ui.widgets").hover() end, desc = "Debug Hover" },
        { "<Leader>dp", mode = "n", function() require("dap.ui.widgets").preview() end, desc = "Debug Preview" },
        {
            "<Leader>dq",
            mode = "n",
            function()
                require("dap").terminate()
                require("dapui").close()
            end,
            desc = "Stop Debugging"
        }
    }
}
