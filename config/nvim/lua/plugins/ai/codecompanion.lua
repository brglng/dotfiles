return {
    "olimorris/codecompanion.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
        "zbirenbaum/copilot.lua",
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
                        opts = {
                            stream = true,
                        },
                        handlers = {
                            -- REQUIRED OVERRIDES for OpenRouter reasoning tokens and Gemini thought signatures
                            --
                            -- Why these handlers are necessary:
                            -- 1. chat_output: OpenRouter sends reasoning_details → we extract and pass as extra
                            -- 2. parse_message_meta: Convert reasoning_details to output.reasoning for display
                            -- 3. form_messages: We convert extra_content → reasoning_details at MESSAGE level (API format)
                            --
                            -- References:
                            -- - https://openrouter.ai/docs/guides/best-practices/reasoning-tokens
                            -- - https://openrouter.ai/docs/guides/features/tool-calling#interleaved-thinking

                            form_messages = function(self, messages)
                                return {
                                    messages = vim
                                        .iter(messages)
                                        :map(function(m)
                                            local tool_calls, reasoning_details = nil, nil

                                            -- Preserve reasoning data in messages for models that need it
                                            if m.reasoning and m.reasoning._data then
                                                reasoning_details = reasoning_details or {}
                                                -- Handle encrypted reasoning (thought signatures from Gemini, etc.)
                                                if m.reasoning._data.encrypted then
                                                    table.insert(reasoning_details, {
                                                        type = "reasoning.encrypted",
                                                        data = m.reasoning._data.encrypted,
                                                        id = m.reasoning._data.id,
                                                        format = m.reasoning._data.format or "openrouter-v1",
                                                        index = #reasoning_details,
                                                    })
                                                end
                                            end

                                            -- Extract thought signatures from tool_calls and convert to reasoning_details
                                            if m.tools and m.tools.calls then
                                                tool_calls = vim
                                                    .iter(m.tools.calls)
                                                    :map(function(tc)
                                                        if tc.extra_content and tc.extra_content.google then
                                                            reasoning_details = reasoning_details or {}
                                                            table.insert(reasoning_details, {
                                                                type = "reasoning.encrypted",
                                                                data = tc.extra_content.google.thought_signature,
                                                                id = tc.id,
                                                                format = "google-gemini-v1",
                                                                index = #reasoning_details,
                                                            })
                                                        end
                                                        return {
                                                            id = tc.id,
                                                            type = tc.type,
                                                            ["function"] = tc["function"],
                                                        }
                                                    end)
                                                    :totable()
                                            end

                                            local msg = {
                                                role = m.role,
                                                content = m.content,
                                                tool_calls = tool_calls,
                                                tool_call_id = m.tools and m.tools.call_id or nil,
                                            }
                                            if reasoning_details then
                                                msg.reasoning_details = reasoning_details
                                            end
                                            return msg
                                        end)
                                        :totable(),
                                }
                            end,

                            -- Extract reasoning content from OpenRouter's reasoning_details
                            -- This is called by chat.init.lua after chat_output to process extra fields
                            -- Reference: https://openrouter.ai/docs/guides/best-practices/reasoning-tokens#responses-api-shape
                            parse_message_meta = function(self, data)
                                local extra = data.extra
                                if not extra or not extra.reasoning_details then
                                    return data
                                end

                                local reasoning_content = {}
                                local reasoning_data = {}

                                for _, detail in ipairs(extra.reasoning_details) do
                                    -- Handle different reasoning detail types
                                    -- Types: reasoning.text, reasoning.summary, reasoning.encrypted
                                    if detail.type == "reasoning.text" and detail.text then
                                        table.insert(reasoning_content, detail.text)
                                        -- Store signature if present for later use
                                        if detail.signature then
                                            reasoning_data.signature = detail.signature
                                        end
                                    elseif detail.type == "reasoning.summary" and detail.summary then
                                        table.insert(reasoning_content, detail.summary)
                                    elseif detail.type == "reasoning.encrypted" and detail.data then
                                        -- Store encrypted data for preserving in subsequent requests
                                        reasoning_data.encrypted = detail.data
                                        reasoning_data.id = detail.id
                                        reasoning_data.format = detail.format
                                    end
                                end

                                -- Set reasoning output if we have any content
                                if #reasoning_content > 0 then
                                    data.output.reasoning = data.output.reasoning or {}
                                    data.output.reasoning.content =
                                    table.concat(reasoning_content, "\n\n")
                                    if next(reasoning_data) then
                                        data.output.reasoning._data = reasoning_data
                                    end
                                elseif next(reasoning_data) then
                                    -- Even without visible content, preserve encrypted reasoning data
                                    data.output.reasoning = data.output.reasoning or {}
                                    data.output.reasoning._data = reasoning_data
                                end

                                -- Don't show empty content as a response
                                if data.output.content == "" then
                                    data.output.content = nil
                                end

                                return data
                            end,

                            chat_output = function(self, data, tools)
                                local adapter_utils = require("codecompanion.utils.adapters")
                                if not data or data == "" then
                                    return nil
                                end

                                local data_mod = type(data) == "table" and data.body
                                or adapter_utils.clean_streamed_data(data)
                                local ok, json =
                                pcall(vim.json.decode, data_mod, { luanil = { object = true } })
                                if not ok or not json.choices or #json.choices == 0 then
                                    return nil
                                end

                                -- Extract thought signature from reasoning_details
                                -- Note: In parallel calls (same response), only first tool gets signature
                                -- In sequential calls (multi-step), each response has its own signature
                                local function get_signature(reasoning_details)
                                    if not reasoning_details then
                                        return nil
                                    end
                                    for _, detail in ipairs(reasoning_details) do
                                        if detail.type == "reasoning.encrypted" and detail.data then
                                            return { google = { thought_signature = detail.data } }
                                        end
                                    end
                                end

                                -- Convert OpenRouter reasoning_details to extra_content for tool calls
                                if self.opts.tools and tools then
                                    for _, choice in ipairs(json.choices) do
                                        local delta = self.opts.stream and choice.delta or choice.message
                                        local signature = get_signature(delta and delta.reasoning_details)

                                        if delta and delta.tool_calls then
                                            -- For parallel calls: only first tool in THIS response gets signature
                                            -- For sequential calls: each response has 1 tool, so it always gets signature
                                            local is_parallel = #delta.tool_calls > 1

                                            for i, tool in ipairs(delta.tool_calls) do
                                                local tool_index = tool.index and tonumber(tool.index) or i
                                                local id = tool.id
                                                or string.format("call_%s_%s", json.created, i)

                                                -- Attach signature to first tool in parallel calls, or to all tools in sequential calls
                                                local should_attach_signature = signature
                                                and (not is_parallel or i == 1)

                                                if self.opts.stream then
                                                    -- Find or create tool in streaming mode
                                                    local existing = vim.iter(tools):find(function(t)
                                                        return t._index == tool_index
                                                    end)
                                                    if existing then
                                                        if tool["function"] and tool["function"]["arguments"] then
                                                            existing["function"]["arguments"] = (
                                                            existing["function"]["arguments"] or ""
                                                        )
                                                            .. tool["function"]["arguments"]
                                                        end
                                                        if
                                                            should_attach_signature and not existing.extra_content
                                                        then
                                                            existing.extra_content = signature
                                                        end
                                                    else
                                                        table.insert(tools, {
                                                            _index = tool_index,
                                                            id = id,
                                                            type = tool.type,
                                                            ["function"] = {
                                                                name = tool["function"]["name"],
                                                                arguments = tool["function"]["arguments"] or "",
                                                            },
                                                            extra_content = should_attach_signature and signature
                                                                or nil,
                                                        })
                                                    end
                                                else
                                                    table.insert(tools, {
                                                        _index = i,
                                                        id = id,
                                                        type = tool.type,
                                                        ["function"] = {
                                                            name = tool["function"]["name"],
                                                            arguments = tool["function"]["arguments"] or "",
                                                        },
                                                        extra_content = should_attach_signature and signature
                                                            or nil,
                                                    })
                                                end
                                            end
                                        end
                                    end
                                end

                                local choice = json.choices[1]
                                local delta = self.opts.stream and choice.delta or choice.message

                                if not delta then
                                    return nil
                                end

                                -- Build extra fields for parse_message_meta to process
                                local extra = nil
                                if delta.reasoning_details then
                                    extra = { reasoning_details = delta.reasoning_details }
                                end

                                return {
                                    status = "success",
                                    output = { role = delta.role, content = delta.content },
                                    extra = extra,
                                }
                            end,
                        },
                        schema = {
                            model = {
                                default = "~openai/gpt-5.5-pro",
                                choices = {
                                    ["~anthropic/claude-fable-lateset"] = {},
                                    ["~anthropic/claude-haiku-lateset"] = {},
                                    ["~anthropic/claude-sonnet-lateset"] = {},
                                    ["~anthropic/claude-opus-lateset"] = {},
                                    ["openai/gpt-5.5"] = {},
                                    ["openai/gpt-5.5-pro"] = {},
                                    ["deepseek/deepseek-v4-pro"] = {},
                                    ["deepseek/deepseek-v4-flash"] = {},
                                    ["qwen/qwen3.7-max"] = {},
                                    ["qwen/qwen3.7-plus"] = {},
                                    ["qwen/qwen3.7-flash"] = {},
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
                    -- model = "gpt-5.5",
                    name = "openrouter",
                    model = "openai/gpt-5.5-pro",
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
                    -- name = "copilot",
                    -- model = "gpt-5.5",
                    name = "openrouter",
                    model = "openai/gpt-5.5-pro",
                },
            },
            cmd = {
                adapter = {
                    -- name = "copilot",
                    -- model = "gpt-5.5",
                    name = "openrouter",
                    model = "openai/gpt-5.5-pro",
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
                    -- adapter = "copilot",
                    -- model = "gpt-5.5",
                    adapter = "openrouter",
                    model = "deepseek/deepseek-v4-flash",
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
