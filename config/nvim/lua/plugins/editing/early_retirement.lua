return {
    "chrisgrieser/nvim-early-retirement",
    event = "VeryLazy",
    enabled = true,
    opts = {
        retirementAgeMins = 20,
        ignoredFiletypes = {},
        minimumBufferNum = 10,
        ignoreUnloadedBufs = false,
        deleteBufferWhenFileDeleted = false,
    }
}
