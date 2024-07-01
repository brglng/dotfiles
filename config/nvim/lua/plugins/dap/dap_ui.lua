return {
    "rcarriga/nvim-dap-ui",
    dependencies = {
        "mfussenegger/nvim-dap",
        "nvim-neotest/nvim-nio"
    },
    opts = {},
    keys = {
        { "<F5>", mode = "n", function() require("brglng.dap_util").start_debugging() end, desc = "Continue" },
    }
}
