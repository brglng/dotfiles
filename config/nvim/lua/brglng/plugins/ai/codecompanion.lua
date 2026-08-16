local skills = require("brglng.skills")

return {
    "olimorris/codecompanion.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
        -- "ravitemer/codecompanion-history.nvim",
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
            acp = {
                pi = function()
                    local helpers = require("codecompanion.adapters.acp.helpers")
                    return {
                        name = "pi",
                        formatted_name = "Pi",
                        type = "acp",
                        roles = {
                            llm = "assistant",
                            user = "user",
                        },
                        commands = {
                            default = {
                                "pi-acp"
                            }
                        },
                        defaults = {
                            mcpServers = {},
                            timeout = 300000,
                        },
                        parameters = {
                            protocolVersion = 1,
                            clientCapabilities = {
                                fs = { readTextFile = true, writeTextFile = true },
                            },
                            clientInfo = {
                                name = "CodeCompanion.nvim",
                                version = "1.0.0",
                            }
                        },
                        handlers = {
                            setup = function(self)
                                return true
                            end,
                            auth = function(self)
                                return true
                            end,
                            form_messages = function(self, messages, capabilities)
                                return helpers.form_messages(self, messages, capabilities)
                            end,
                            on_exit = function(self, code) end,
                        },
                    }
                end
            },
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
                        name = "poe",
                        vendor = "poe",
                        formatted_name = "Poe",
                        env = {
                            url = "https://api.poe.com",
                            chat_url = "/v1/chat/completions",
                            api_key = "POE_API_KEY",
                        },
                        opts = {
                            stream = true,
                        },
                        schema = {
                            model = {
                                default = "kimi-k3",
                                choices = {
                                    "kimi-k3",
                                    "claude-sonnet-4.6",
                                    "claude-opus-4.8",
                                    "zpan-fable5-code",
                                    "zpan-gpt-5.6-sol",
                                    "zpan-gpt-5.6-terra",
                                    "zpan-gpt-5.6-luna",
                                    "zpan-opus-5-agent",
                                    "zpan-sonnet-5",
                                }
                            },
                        }
                    })
                end,
                aliyun_bailian_tokenplan_enterprise = function()
                    return require("codecompanion.adapters").extend("openai_compatible", {
                        -- url = "https://token-plan.cn-beijing.maas.aliyuncs.com/apps/anthropic/v1/messages",
                        vendor = "alibaba",
                        name = "aliyun_bailian_tokenplan_enterprise",
                        formatted_name = "阿里云百炼 Token Plan 企业版",
                        env = {
                            url = "https://token-plan.cn-beijing.maas.aliyuncs.com/compatible-mode",
                            chat_url = "/v1/chat/completions",
                            api_key = "ALIYUN_BAILIAN_TOKENPLAN_ENTERPRISE_API_KEY",
                        },
                        opts = {
                            stream = true,
                        },
                        schema = {
                            model = {
                                default = "glm-5.2",
                                choices = {
                                    "glm-5.2",
                                    "deepseek-v4-flash-0731",
                                    "qwen3.8-max"
                                }
                            },
                        }
                    })
                end,
                opts = {
                    allow_insecure = false,
                    show_model_choices = true
                }
            }
        },
        interactions = {
            chat = {
                -- adapter = {
                --     name = "aliyun_bailian_tokenplan_enterprise",
                --     model = "glm-5.2",
                -- },
                adapter = "pi",
                keymaps = {
                    send = {
                        modes = { n = "<CR>", i = "<C-CR>" },
                    },
                    close = {
                        modes = { n = "q", i = "<C-d>" },
                    },
                    stop = {
                        modes = { n = "<C-c>", i = "<C-c>" }
                    }
                },
                opts = {
                    system_prompt = function(ctx)
                        local prompt = ctx.default_system_prompt
                        -- The pi ACP adapter is a real Pi process that already loads SYSTEM.md and
                        -- skills natively, so only inject the skills index for HTTP adapters.
                        if not (ctx.adapter and ctx.adapter.type == "acp") then
                            prompt = prompt .. table.concat(vim.fn.readfile(vim.env.BRGLNG_DOTFILES_DIR .. "/pi/agent/SYSTEM.md"), "\n") .. skills.render_available_skills()
                        end
                        return prompt .. string.format(
                            [[
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
                        ["agent"] = {}
                    },
                    opts = {
                        -- Auto-load file reading tools so HTTP chat models can read
                        -- SKILL.md files on demand (see rendered <available_skills> block).
                        default_tools = { "files" },
                    },
                }
            },
            inline = {
                adapter = {
                    name = "poe",
                    model = "claude-opus-4.8"
                },
            },
            cmd = {
                adapter = {
                    name = "poe",
                    model = "claude-opus-4.8"
                },
            },
            cli = {
                agent = "pi",
                agents = {
                    pi = { cmd = "pi", args = {}, description = "Pi Coding Agent" }
                }
            }
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
            },
            -- cli = {
            --     window = {
            --         layout = "tab",
            --     }
            -- }
        },
        extensions = {
            dap = {
                enabled = true,
            },
            history = {
                enabled = false,
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
                    adapter = "openrouter",
                    model = "deepseek/deepseek-v4-flash-0731",
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
        local orig_agent_system_prompt = require("codecompanion.config").config.interactions.chat.tools.groups["agent"].system_prompt
        opts.interactions.chat.tools.groups["agent"].system_prompt = function(group, ctx)
            local prompt = orig_agent_system_prompt(group, ctx)
            prompt, _ = prompt:gsub("<additionalContext>.*</additionalContext>", "")
            return prompt .. "<additionalContext>\n" .. table.concat(vim.fn.readfile(vim.env.BRGLNG_DOTFILES_DIR .. "/pi/agent/SYSTEM.md"), "\n") .. string.format([[
- The user's current working directory is %s.
- The current date is %s.
- The user's Neovim version is %s.
- The user is working on a %s machine. Please respond with system specific commands if applicable.
</additionalContext>
            ]], ctx.cwd, ctx.date, ctx.nvim_version, ctx.os) .. skills.render_available_skills()
        end
        require("codecompanion").setup(opts)

        local function set_cli_win_options()
            vim.cmd("startinsert")
            vim.o.signcolumn = 'no'
            vim.o.foldcolumn = '0'
            vim.o.foldenable = false
            vim.o.statuscolumn = ''
            vim.o.number = false
        end

        vim.api.nvim_create_autocmd("FileType", {
            pattern = "codecompanion_cli",
            callback = set_cli_win_options
        })
        vim.api.nvim_create_autocmd("BufWinEnter", {
            pattern = "*",
            callback = function ()
                if vim.o.filetype == "codecompanion_cli" then
                    set_cli_win_options()
                end
            end
        })
    end,
    keys = {
        { "<leader>cc", "<Cmd>CodeCompanionChat Toggle<CR>", mode = { "n", "v" }, desc = "CodeCompanionChat Toggle" },
        { "<leader>ca", "<Cmd>CodeCompanionChat Add<CR>", mode = { "n", "v" }, desc = "CodeCompanionChat Add" },
        -- { "<leader>ch", "<Cmd>CodeCompanionHistory<CR>", mode = { "n", "v" }, desc = "CodeCompanionHistory" },
        { "<Leader>ci", "<Cmd>CodeCompanion <CR>", mode = { "n", "v" }, desc = "CodeCompanion Inline edit" },
        { "<Leader>cr", "<Cmd>CodeCompanionCodeReview<CR>", mode = { "n", "v" }, desc = "CodeCompanion Code Review" },
        { "<leader>c;", "<Cmd>CodeCompanionCLI<CR>", mode = { "n", "v" }, desc = "CodeCompanionCLI" },
        { "<leader>c/", "<Cmd>CodeCompanionActions<CR>", mode = { "n", "v" }, desc = "CodeCompanionActions" },
    }
}
