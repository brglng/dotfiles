local skills = require("brglng.skills")

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
        jina = function()
          return require("codecompanion.adapters").extend("jina", {
            env = {
              api_key = "JINA_API_KEY",
            },
            -- Upstream jina adapter only implements fetch_webpage; add the
            -- missing web_search method backed by https://s.jina.ai
            methods = {
              tools = {
                web_search = {
                  ---Prepare the adapter for the web_search tool
                  ---@param self CodeCompanion.HTTPAdapter
                  ---@param opts table|nil Tool options
                  ---@param data table The data from the LLM's tool call
                  setup = function(self, opts, data)
                    self.url = "https://s.jina.ai"
                    self.headers = vim.tbl_deep_extend("force", self.headers, {
                      ["Content-Type"] = "application/json",
                      ["Accept"] = "application/json",
                      ["Authorization"] = "Bearer ${api_key}",
                    })
                    self.handlers.set_body = function()
                      local body = { q = data.query }
                      local domains = data.domains
                      if type(domains) == "string" and domains ~= "" then
                        domains = vim.split(domains, ",", { trimempty = true })
                      end
                      if type(domains) == "table" and #domains > 0 then
                        body.domains = domains
                      end
                      return body
                    end
                  end,
                  ---Process the output from the search
                  ---@param self CodeCompanion.HTTPAdapter
                  ---@param data table The data returned from the search
                  ---@return table{status: string, content: any}|nil
                  callback = function(self, data)
                    local ok, body = pcall(vim.json.decode, data.body or "")
                    if not ok or type(body) ~= "table" then
                      return {
                        status = "error",
                        content = "Could not parse JSON response",
                      }
                    end
                    if body.code ~= 200 then
                      return {
                        status = "error",
                        content = body.message
                          or body.readable_message
                          or ("Error " .. tostring(body.code)),
                      }
                    end
                    if body.data == nil or #body.data == 0 then
                      return {
                        status = "error",
                        content = "No results found",
                      }
                    end
                    local output = vim
                      .iter(body.data)
                      :map(function(result)
                        local content = result.content or ""
                        if result.description and result.description ~= "" then
                          content = result.description .. "\n\n" .. content
                        end
                        return {
                          title = result.title or "",
                          url = result.url or "",
                          content = content,
                        }
                      end)
                      :totable()
                    return {
                      status = "success",
                      content = output,
                    }
                  end,
                },
              },
            },
          })
        end,
        poe = function()
          return require("codecompanion.adapters").extend("openai_compatible", {
            name = "poe",
            vendor = "poe",
            formatted_name = "Poe",
            env = {
              url = "https://api.poe.com/v1",
              chat_url = "/chat/completions",
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
        bailian = function()
          return require("codecompanion.adapters").extend("openai_compatible", {
            -- url = "https://token-plan.cn-beijing.maas.aliyuncs.com/apps/anthropic/v1/messages",
            vendor = "alibaba",
            name = "bailian",
            formatted_name = "阿里云百炼",
            env = {
              url = "https://token-plan.cn-beijing.maas.aliyuncs.com/compatible-mode/v1",
              chat_url = "/chat/completions",
              api_key = "DASHSCOPE_API_KEY",
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
              reasoning_effort = {
                enabled = function()
                  return true
                end,
                default = "max",
              },
              max_tokens = {
                default = 128000,
              },
            }
          })
        end,
        loostone = function()
          return require("codecompanion.adapters").extend("openai_compatible", {
            name = "loostone",
            formatted_name = "炉石 AI 平台",
            env = {
              url = "http://192.168.5.46:18000/v1",
              chat_url = "/chat/completions",
              api_key = "LOOSTONE_API_KEY",
            },
            opts = {
              stream = true,
            },
            schema = {
              model = {
                default = "glm-5.3-flash",
                choices = {
                  "deepseek-v4-flash",
                  "deepseek-v4-pro",
                  "glm-5.3-flash",
                  "GLM-5.3",
                  "kimi-k3",
                }
              },
              reasoning_effort = {
                enabled = function()
                  return true
                end,
                default = "max",
              },
              max_tokens = {
                default = 128000,
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
        adapter = {
          name = "openrouter",
          model = "deepseek/deepseek-v4-flash-0731"
        },
        -- adapter = "pi",
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
            -- The pi ACP adapter is a real Pi process that already loads APPEND_SYSTEM.md and
            -- skills natively, so only inject the skills index for HTTP adapters.
            if not (ctx.adapter and ctx.adapter.type == "acp") then
              prompt = prompt .. table.concat(vim.fn.readfile(vim.env.BRGLNG_DOTFILES_DIR .. "/pi/agent/APPEND_SYSTEM.md"), "\n") .. skills.render_available_skills()
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
            agent = {}
          },
          web_search = {
            opts = {
              adapter = "jina"
            }
          },
          opts = {
            -- Auto-load file reading tools so HTTP chat models can read
            -- SKILL.md files on demand (see rendered <available_skills> block).
            default_tools = { "agent", "fetch_webpage", "files", "search_help", "web_search" },
          },
        }
      },
      inline = {
        adapter = {
          name = "openrouter",
          model = "deepseek/deepseek-v4-flash-0731"
        },
      },
      cmd = {
        adapter = {
          name = "openrouter",
          model = "deepseek/deepseek-v4-flash-0731"
        },
      },
      cli = {
        agent = "pi",
        agents = {
          pi = { cmd = "pi", args = { "--tui-mode", "fullscreen" }, description = "Pi Coding Agent" }
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
          adapter = "openrouter",
          model = "openai/gpt-5.6-luna",
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
      return prompt .. "<additionalContext>\n" .. table.concat(vim.fn.readfile(vim.env.BRGLNG_DOTFILES_DIR .. "/pi/agent/APPEND_SYSTEM.md"), "\n") .. string.format([[
- The user's current working directory is %s.
- The current date is %s.
- The user's Neovim version is %s.
- The user is working on a %s machine. Please respond with system specific commands if applicable.
</additionalContext>
            ]], ctx.cwd, ctx.date, ctx.nvim_version, ctx.os) .. skills.render_available_skills()
    end
    require("codecompanion").setup(opts)

    local function set_chat_win_options()
      vim.cmd("startinsert")
      vim.wo.scrolloff = 5
    end
    local function set_cli_win_options()
      vim.cmd("startinsert")
      vim.wo.signcolumn = 'no'
      vim.wo.foldcolumn = '0'
      vim.wo.foldenable = false
      vim.wo.statuscolumn = ''
      vim.wo.number = false
      vim.wo.cursorline = false
    end
    vim.api.nvim_create_autocmd({ "FileType", "BufWinEnter" }, {
      pattern = { "*" },
      callback = function ()
        if vim.bo.filetype == "codecompanion" then
          set_chat_win_options()
        elseif vim.bo.filetype == "codecompanion_cli" then
          set_cli_win_options()
        end
      end
    })
    vim.api.nvim_create_autocmd("BufEnter", {
      pattern = "*",
      callback = function()
        if vim.bo.filetype == "codecompanion_cli" then
          vim.cmd("startinsert")
          vim.wo.scrolloff = 5
        end
      end
    })
  end,
  keys = {
    { "<leader>cc", "<Cmd>CodeCompanionChat Toggle<CR>", mode = { "n", "v" }, desc = "CodeCompanionChat Toggle" },
    { "<leader>ca", "<Cmd>CodeCompanionChat Add<CR>", mode = { "n", "v" }, desc = "CodeCompanionChat Add" },
    { "<leader>ch", "<Cmd>CodeCompanionHistory<CR>", mode = { "n", "v" }, desc = "CodeCompanionHistory" },
    { "<Leader>ci", "<Cmd>CodeCompanion <CR>", mode = { "n", "v" }, desc = "CodeCompanion Inline edit" },
    { "<Leader>cr", "<Cmd>CodeCompanionCodeReview<CR>", mode = { "n", "v" }, desc = "CodeCompanion Code Review" },
    { "<leader>c;", "<Cmd>CodeCompanionCLI<CR>", mode = { "n", "v" }, desc = "CodeCompanionCLI" },
    { "<leader>c/", "<Cmd>CodeCompanionActions<CR>", mode = { "n", "v" }, desc = "CodeCompanionActions" },
  }
}
