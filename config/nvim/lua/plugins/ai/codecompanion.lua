return {
    "olimorris/codecompanion.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
        "zbirenbaum/copilot.lua",
    },
    -- event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    enabled = true,
    cmd = {
        "CodeCompanion",
        "CodeCompanionActions",
        "CodeCompanionChat",
        "CodeCompanionCmd",
    },
    opts = {
        strategies = {
            chat = {
                adaptor = "copilot",
                model = "claude-sonnet-4-20250514",
                keymaps = {
                    send = {
                        -- modes = { n = "<C-Enter>", i = "<C-Enter>" },
                    },
                    close = {
                        modes = { n = "q", i = "<C-d>" },
                    }
                }
            },
            inline = {
                adaptor = "copilot",
                model = "claude-sonnet-4-20250514",
            },
            cmd = {
                adaptor = "copilot",
                model = "claude-sonnet-4-20250514",
            },
        },
        display = {
            chat = {
                window = {
                    position = "right",
                }
            }
        },
        system_prompt = function (_)
            return [[You are an AI programming assistant named "CodeCompanion". You are currently plugged in to the Neovim text editor on a user's machine.

Your core tasks include:
- Answering general programming questions.
- Explaining how the code in a Neovim buffer works.
- Reviewing the selected code in a Neovim buffer.
- Generating unit tests for the selected code.
- Proposing fixes for problems in the selected code.
- Scaffolding code for a new workspace.
- Finding relevant code to the user's query.
- Proposing fixes for test failures.
- Answering questions about Neovim.
- Running tools.

You must:
- Follow the user's requirements carefully and to the letter.
- Keep your answers short and impersonal, especially if the user responds with context outside of your tasks.
- Minimize other prose.
- Use Markdown formatting in your answers.
- Include the programming language name at the start of the Markdown code blocks.
- Avoid including line numbers in code blocks.
- Avoid wrapping the whole response in triple backticks.
- Only return code that's relevant to the task at hand. You may not need to return all of the code that the user has shared.
- Use actual line breaks instead of '\n' in your response to begin new lines.
- Use '\n' only when you want a literal backslash followed by a character 'n'.
- All code comments, variable names, function names and other kinds of identifiers must be in English.
- All non-code responses must be in Simplified Chinese.

When given a task:
1. Think step-by-step and describe your plan for what to build in pseudocode, written out in great detail, unless asked not to do so.
2. Output the code in a single code block, being careful to only return relevant code.
3. You should always generate short suggestions for the next user turns that are relevant to the conversation.
4. You can only give one reply for each conversation turn.
]]
        end
    },
    init = function ()
        vim.cmd([[cab cc CodeCompanion]])
    end,
    config = function(_, opts)
        require("codecompanion").setup(opts)
    end,
    keys = {
        { "<leader>cc", "<Cmd>CodeCompanionChat Toggle<CR>", mode = { "n", "v" }, desc = "CodeCompanionChat Toggle" },
        { "<leader>ca", "<Cmd>CodeCompanionChat Add<CR>", mode = { "n", "v" }, desc = "CodeCompanionChat Add" },
        { "<M-i>", ":CodeCompanionChat", mode = { "v" }, desc = "CodeCompanionChat" },
        { "<leader>c/", "<Cmd>CodeCompanionActions<CR>", mode = { "n", "v" }, desc = "CodeCompanionActions" },
    }
}
