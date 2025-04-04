return {
    "github/copilot.vim",
    -- build = ":Copilot setup"
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    enabled = true,
}
