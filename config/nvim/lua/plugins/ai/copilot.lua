return {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = { "InsertEnter", "CmdlineEnter" },
    opts = {
        suggestion = {
            auto_trigger = true,
            keymap = {
                accept = nil,
                accept_word = nil,
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
        end, mode = "i", desc = "Accept Copilot suggestion (all)" },
        { "<C-Right>", function()
            if require("copilot.suggestion").is_visible() then
                require("copilot.suggestion").accept_word()
            else
                return "<C-Right>"
            end
        end, mode = "i", expr = true, noremap = true, desc = "Accept Copilot suggestion (word)" },
        { "<M-f>", function()
            if require("copilot.suggestion").is_visible() then
                require("copilot.suggestion").accept_word()
            else
                return "<C-Right>"
            end
        end, mode = "i", expr = true, noremap = true, desc = "Accept Copilot suggestion (word)" },
    },
}
