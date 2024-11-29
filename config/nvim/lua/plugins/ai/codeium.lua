return {
    "Exafunction/codeium.nvim",
    cond = vim.fn.hostname() ~= 'APSH-1315',
    cmd = "Codeium",
    build = ":Codeium Auth",
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
