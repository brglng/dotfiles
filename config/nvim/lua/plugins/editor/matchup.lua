return {
    "andymass/vim-matchup",
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    init = function()
        vim.g.loaded_matchit = 1
    end,
    config = function()
        -- vim.g.matchup_matchparen_offscreen = { method = "popup" }
    end,
}
