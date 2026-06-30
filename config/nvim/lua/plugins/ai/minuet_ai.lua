return {
    'milanglacier/minuet-ai.nvim',
    event = { "InsertEnter", "CmdlineEnter" },
    opts = {
        cmp = {
            enable_auto_complete = false,
        },
        virtualtext = {
            auto_trigger_ft = { "*" },
            keymap = {
                prev = "<M-[>",
                next = "<M-]>",
                dissmiss = "<C-]>",
            },
            show_on_completion_menu = false,
        },
        proxy = "http://localhost:1087",
        provider = "openai_compatible",
        provider_options = {
            openai_compatible = {
                model = "anthropic/claude-opus-4.8",
                stream = true,
                end_point = "https://openrouter.ai/api/v1/chat/completions",
                api_key = "OPENROUTER_API_KEY",
                name = "OpenRouter",
                optional = {
                    stop = nil,
                    max_tokens = nil,
                    reasoning = { effort = "none" }
                }
            }
        }
    },
    config = function(_, opts)
        require("minuet").setup(opts)
    end,
}
