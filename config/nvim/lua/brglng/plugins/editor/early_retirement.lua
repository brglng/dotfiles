return {
    "chrisgrieser/nvim-early-retirement",
    event = "VeryLazy",
    enabled = false,
    opts = {
        retirementAgeMins = 20,
        ignoredFiletypes = {},
        minimumBufferNum = 15,
        ignoreUnloadedBufs = false,
        deleteBufferWhenFileDeleted = false,
    },
    config = function(_, opts)
        require("early-retirement").setup(opts)
    end,
}
