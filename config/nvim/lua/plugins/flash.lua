require("flash").setup {
    -- highlight = {
    --     groups = {
    --         match = "FlashCurrent"
    --     }
    -- },
    modes = {
        char = {
            char_actions = function(motion)
                return {
                    -- clever-f style
                    [motion:lower()] = "next",
                    [motion:upper()] = "prev",
                }
            end
        }
    }
}
