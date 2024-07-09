return {
    "rcarriga/nvim-dap-ui",
    dependencies = {
        "mfussenegger/nvim-dap",
        "nvim-neotest/nvim-nio"
    },
    opts = {},
    keys = {
        { "<F5>", mode = "n", function() require("brglng.daputil").start_debugging() end, desc = "Continue" },
    }
}
