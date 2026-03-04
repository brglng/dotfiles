return {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = { "InsertEnter", "CmdlineEnter" },
    opts = {
        suggestion = {
            auto_trigger = true,
            keymap = {
                accept = nil
            }
        },
        filetypes = {
            yaml = true,
            markdown = true,
            gitcommit = true,
            hgcommit = true,
        }
    },
    config = function(_, opts)
        local brglng = require("brglng")
        require("copilot").setup(opts)
        brglng.hl.transform_tbl {
            CopilotAnnotation = { link = "Comment" },
            CopilotSuggestion = { link = "Comment" },
        }
    end,
    keys = {
        { "<M-\\>", function()
            if not require("copilot.suggestion").is_visible() then
                require("copilot.suggestion").next()
            end
        end, mode = "i", desc = "Accept Copilot suggestion" },
    },
}
