return {
    "Exafunction/codeium.nvim",
    init = function()
        vim.env.DEBUG_CODEIUM = "error"
    end,
    dependencies = {
        "nvim-lua/plenary.nvim"
    },
    opts = {
        enable_chat = true,
        detect_proxy = true,
    }
}
