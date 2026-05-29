return {
    "olimorris/codecompanion.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
        "zbirenbaum/copilot.lua",
        "ravitemer/codecompanion-history.nvim",
        "franco-ruggeri/codecompanion-spinner.nvim",
        "Davidyz/codecompanion-dap.nvim"
    },
    enabled = true,
    cmd = {
        "CodeCompanion",
        "CodeCompanionActions",
        "CodeCompanionChat",
        "CodeCompanionCmd",
        "CodeCompanionCLI",
        "CodeCompanionHistory",
        "CodeCompanionSummaries"
    },
    opts = {
        adapters = {
            http = {
                openrouter = function()
                    return require("codecompanion.adapters").extend("openai_compatible", {
                        env = {
                            url = "https://openrouter.ai/api",
                            api_key = "OPENROUTER_API_KEY",
                            chat_url = "/v1/chat/completions",
                        },
                        headers = {
                            ["Content-Type"] = "application/json",
                            ["HTTP-Referer"] = "https://github.com/olimorris/codecompanion.nvim", -- Optional but recommended by OpenRouter
                            ["X-Title"] = "Neovim CodeCompanion", -- Optional OpenRouter app title
                        },
                        schema = {
                            model = {
                                default = "deepseek/deepseek-v4-pro",
                                choices = {
                                    ["deepseek/deepseek-v4-pro"] = {},
                                    ["deepseek/deepseek-v4-flash"] = {},
                                },
                            },
                        },
                    })
                end,
                opts = {
                    allow_insecure = true,
                    proxy = "socks5://127.0.0.1:1086",
                    show_model_choices = true
                }
            }
        },
        interactions = {
            chat = {
                adapter = {
                    -- name = "copilot",
                    -- model = "claude-sonnet-4.6",
                    name = "openrouter",
                    model = "deepseek/deepseek-v4-pro",
                },
                keymaps = {
                    -- send = {
                    --     modes = { n = "<C-CR>", i = "<C-CR>" },
                    -- },
                    -- close = {
                    --     modes = { n = "q", i = "<C-c>" },
                    -- }
                },
                opts = {
                    system_prompt = function(ctx)
                        return ctx.default_system_prompt .. string.format(
                            [[
- All non-code text responses must be written in the same language as the language of the user's prompt regardless of the language of the code.
- All code including comments must be written in English regardless of the language of the user's request, except for the following cases:
    - Keep any latin/western/Russian people names, place/street names, country/state names, etc. in their original language and do not translate them to English.
    - For non-latin (especially CJK) people names, place/street names, country/state names, etc., if the original language is not English, translate them to English, and add a pair of parentheses after the English translation containing the original name in its original language. For example, if the original name is "张三", translate it to "San Zhang (张三)".
- Strip leading spaces or tabs in blank lines in the code.

When writing code in Python, follow the following code conventions:

- Import standard library packages first, followed by third-party packages, and finally local scripts, with a blank line between these three parts, and each part must be strictly sorted alphabetically.
- Add two blank lines between each function or method.
- Nested classes and nested functions are prohibited (except when they are really useful or small, or being explicitly asked for), but lambda functions are allowed.
- Function default parameters should be avoided when they are not really necessary.
- Importing inside a function is strictly prohibited except when the import is only used in a function which is only executed during testing.
- Wrap the main program in a `main` function instead of write directly under a `if __name__ == "__main__:` block.
- Type hints are preferred where the types are not obvious and at function prototypes. The `None` return type must be omitted. Types should be imported to the global namespace if they do not conflict. Built-in type names such as `list`, `tuple`, and `dict` should be preferred over the counterparts in the `typing` package, such as `typing.List`, `typing.Tuple`, and `typing.Dict`.
- Prefer `numpy.typing.NDArray` over `np.ndarray`.
- Use type parameters.
- Add assertions at the beginning of functions for the shapes of `NDArray`s and `Tensor`s.
- If there is docstring, prefer NumPy style.

Additional context:

- The user's current working directory is %s.
- The current date is %s.
- The user's Neovim version is %s.
- The user is working on a %s machine. Please respond with system specific commands if applicable.
]],
                            -- ctx.language,
                            ctx.cwd,
                            ctx.date,
                            ctx.nvim_version,
                            ctx.os
                        )
                    end,
                }
            },
            inline = {
                adapter = {
                    -- name = "copilot",
                    -- model = "claude-sonnet-4.6",
                    name = "openrouter",
                    model = "deepseek/deepseek-v4-pro",
                },
            },
            cmd = {
                adapter = {
                    -- name = "copilot",
                    -- model = "claude-sonnet-4.6",
                    name = "openrouter",
                    model = "deepseek/deepseek-v4-pro",
                },
            },
        },
        display = {
            chat = {
                window = {
                    position = "right",
                }
            }
        },
        extensions = {
            dap = {
                enabled = true,
            },
            history = {
                enabled = true,
                opts = {
                    picker_keymaps = {
                        rename = { n = "r", i = "<M-r>" },
                        delete = { n = "d", i = "<C-d>" },
                        duplicate = { n = "<C-y>", i = "<C-y>" },
                    }
                }
            },
            spinner = {}
        }
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
        { "<leader>ch", "<Cmd>CodeCompanionHistory<CR>", mode = { "n", "v" }, desc = "CodeCompanionHistory" },
        { "<M-i>", ":CodeCompanionChat", mode = { "v" }, desc = "CodeCompanionChat" },
        { "<leader>c/", "<Cmd>CodeCompanionActions<CR>", mode = { "n", "v" }, desc = "CodeCompanionActions" },
    }
}
