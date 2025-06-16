return {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = { "InsertEnter", "CmdlineEnter" },
    opts = {
        suggestion = {
            auto_trigger = true,
            keymap = {
                accept = "<C-CR>"
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
    end
}
