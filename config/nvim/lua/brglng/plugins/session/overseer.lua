return {
    "stevearc/overseer.nvim",

    event = { "BufReadPost", "BufNewFile" },

    cmd = { "OverseerToggle", "OverseerOpen", "OverseerRun", "OverseerTaskAction", "OverseerShell" },

    ---@module 'overseer'
    ---@type overseer.SetupOpts
    opts = {
    },

    keys = {
        { "<C-S-b>", mode = { "n", "i", "t" },  "<Cmd>OverseerRun<CR>", desc = "Run Task" },
        { "<C-S-p>", mode = { "n", "i", "t" }, "<Cmd>OverseerToggle<CR>", desc = "Toggle Task List" },
    }
}
