return {
    "olimorris/codecompanion.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
        "ravitemer/codecompanion-history.nvim",
        "franco-ruggeri/codecompanion-spinner.nvim",
        "Davidyz/codecompanion-dap.nvim",
        "jinzhongjia/codecompanion-gitcommit.nvim"
    },
    enabled = true,
    ft = { "codecompanion", "gitcommit" },
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
                    return require("codecompanion.adapters").extend("openrouter", {
                        env = {
                            api_key = "OPENROUTER_API_KEY",
                        },
                    })
                end,
                poe = function()
                    return require("codecompanion.adapters").extend("openai_compatible", {
                        env = {
                            url = "https://api.poe.com",
                            api_key = "POE_API_KEY",
                            chat_url = "/v1/chat/completions",
                        },
                        headers = {
                            ["Content-Type"] = "application/json",
                        },
                        opts = {
                            stream = true,
                        },
                        schema = {
                            model = {
                                default = "kimi-k3",
                                choices = {
                                    ["claude-sonnet-4.6"] = {},
                                    ["claude-opus-4.6"] = {},
                                    ["claude-opus-4.8"] = {},
                                    ["glm-5.2"] = {},
                                },
                            },
                        }
                    })
                end,
                aliyun_bailian_tokenplan = function()
                    return require("codecompanion.adapters").extend("openai_compatible", {
                        env = {
                            url = "https://token-plan.cn-beijing.maas.aliyuncs.com/compatible-mode/v1",
                            api_key = "ALIYUN_BAILIAN_API_KEY",
                            chat_url = "/chat/completions",
                        },
                        headers = {
                            ["Content-Type"] = "application/json",
                        },
                        opts = {
                            stream = true,
                        },
                        schema = {
                            model = {
                                default = "glm-5.2",
                                choices = {
                                    ["glm-5.2"] = {},
                                    ["kimi-k3"] = {},
                                },
                            },
                        }
                    })
                end,
                opts = {
                    allow_insecure = false,
                    -- proxy = "socks5://127.0.0.1:1086",
                    show_model_choices = true
                }
            }
        },
        interactions = {
            chat = {
                adapter = {
                    name = "poe",
                    model = "kimi-k3"
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

- Import standard library packages first, followed by third-party packages, and finally local scripts, and each part must be strictly sorted alphabetically.
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
                },
                tools = {
                    groups = {
                        ["agent"] = {
                            -- https://github.com/olimorris/codecompanion.nvim/blob/main/lua/codecompanion/config.lua#L115
                            system_prompt = function(group, ctx)
                                return string.format(
                [[<instructions>
You are an automated coding agent with expert-level knowledge across many programming languages and frameworks.
The user will ask a question or ask you to perform a task. Use the available tools to gather context and take actions.
If you can infer the project type from the user's query or context, keep it in mind when making changes.
If the user wants you to implement a feature without specifying files, break the request into smaller concepts and think about the kinds of files you need for each.
Call multiple tools if you aren't sure which is relevant. Call tools repeatedly until the task is complete — don't give up unless the request truly cannot be fulfilled.
Gather context first rather than making assumptions. Think creatively and explore the workspace to make a complete fix.
Don't repeat yourself after a tool call — pick up where you left off.
Don't print terminal commands in a code block unless the user asked for it.
You don't need to read a file already provided in context.
</instructions>
<toolUseInstructions>
Follow the JSON schema carefully and include ALL required properties.
Always output valid JSON when using a tool.
Use tools to take actions rather than asking the user to do it manually.
If you say you'll take an action, go ahead and do it.
Never say the name of a tool to a user — e.g. say "I'll edit the file" not "I'll use the insert_edit_into_file tool".
Prefer calling multiple tools in parallel when possible.
Use file paths given by the user or by tool output.
</toolUseInstructions>
<outputFormatting>
Use proper Markdown formatting. Wrap filenames and symbols in backticks.
Code block examples must use four backticks with the language ID.
If you are providing code changes, use the insert_edit_into_file tool (if available) instead of printing a code block.
</outputFormatting>
<additionalContext>
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

- The user's current working directory is %s.
- The current date is %s.
- The user's Neovim version is %s.
- The user is working on a %s machine. Please respond with system specific commands if applicable.
</additionalContext>]],
                                    ctx.cwd,
                                    ctx.date,
                                    ctx.nvim_version,
                                    ctx.os
                                )
                            end
                        }
                    }
                }
            },
            inline = {
                adapter = {
                    name = "poe",
                    model = "kimi-k3"
                },
            },
            cmd = {
                adapter = {
                    name = "poe",
                    model = "kimi-k3"
                },
            },
        },
        display = {
            chat = {
                window = {
                    position = "right",
                },
                floating_window = {
                    border = (function()
                        if vim.g.neovide then
                            return "solid"
                        else
                            return "rounded"
                        end
                    end)()
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
            gitcommit = {
                opts = {
                    adapter = "poe",
                    model = "kimi-k3",
                    languages = { "English" }
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
