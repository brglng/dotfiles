return {
    'milanglacier/minuet-ai.nvim',
    enabled = false,
    event = { "InsertEnter", "CmdlineEnter" },
    opts = {
        cmp = {
            enable_auto_complete = false,
        },
        virtualtext = {
            auto_trigger_ft = { "*" },
            auto_trigger_ignore_ft = { "gitcommit", "TelescopePrompt" },
            keymap = {
                prev = "<M-[>",
                next = "<M-]>",
                dissmiss = "<C-]>",
            },
            show_on_completion_menu = true,
        },
        proxy = "http://localhost:1087",
        provider = "openai_compatible",
        provider_options = {
            openai_compatible = {
                model = "openai/gpt-5.4-mini",
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
        },
        context_ratio = 0.1,
        request_timeout = 10,
    },
    config = function(_, opts)
        require("minuet").setup(opts)
    end,
}
