return {
    "folke/flash.nvim",
    config = function ()
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

        -- local hl_search = vim.api.nvim_get_hl(0, { name = "Search", link = false })
        -- local hl_cur_search = vim.api.nvim_get_hl(0, { name = "CurSearch", link = false })
        -- local set_flash_highlights = function ()
        --     if hl_search.reverse then
        --         vim.api_nvim_set_hl(0, { "FlashCursor", { fg = hl_cur_search.fg, bg = hl_cur_search.bg } })
        --     else
        --         vim.api_nvim_set_hl(0, { "FlashCursor", { fg = hl_cur_search.bg, bg = hl_cur_search.fg } })
        --     end
        -- end
        -- vim.api.nvim_create_autocmd("ColorScheme", {
        --     pattern = "*",
        --     callback = set_flash_highlights
        -- })
        -- vim.api.nvim_create_autocmd("OptionSet", {
        --     pattern = "background",
        --     callback = set_flash_highlights
        -- })
    end,
    keys = {
        { "s", mode = { "n", "o", "x" }, function() require("flash").jump() end, desc = "Flash" },
        { "S", mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
        { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
        { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
        { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" }
    }
}
