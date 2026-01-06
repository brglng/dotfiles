return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    dependencies = {
        "williamboman/mason.nvim",
        "ray-x/lsp_signature.nvim",
        "rachartier/tiny-inline-diagnostic.nvim",
        "folke/neoconf.nvim",
    },
    opts = {
        -- log_level = 'debug'
        diagnostic = {
            virtual_text = false,
            -- virtual_text = {
            --     current_line = true,
            -- },
            virtual_lines = false,
            -- virtual_lines = {
            --     only_current_line = false,
            --     highlight_whole_line = false,
            -- },
            float = {
                enabled = false,
                -- border = "none",
                border = (function()
                    if vim.g.neovide then
                        -- return {
                        --     { " ", "NormalFloat" },
                        --     { " ", "NormalFloat" },
                        -- }
                        return "none"
                    else
                        return "rounded"
                    end
                end)(),
                -- border = { '🭽', '▔', '🭾', '▕', '🭿', '▁', '🭼', '▏' }
                focusable = false,
                winhighlight = (function()
                    if vim.g.neovide then
                        return nil
                    else
                        return 'NormalFloat:Normal,FloatBorder:LspDiagnosticFloatBorder'
                    end
                end)()
            },
            signs = {
                text = {
                    [vim.diagnostic.severity.ERROR] = " ",
                    [vim.diagnostic.severity.WARN] = " ",
                    [vim.diagnostic.severity.INFO] = " ",
                    [vim.diagnostic.severity.HINT] = "󰌵 "
                }
            }
        },
        hover = (function()
            if vim.g.neovide then
                return {
                    border = "none",
                    silent = false
                }
            else
                return {
                    border = "rounded",
                    silent = false
                }
            end
        end)(),
        floating_preview = (function()
            if vim.g.neovide then
                return {
                    border = "none",
                    focusable = true,
                }
            else
                return {
                    border = "rounded",
                    focusable = true,
                    winhighlight = "FloatBorder:LspFloatingPreviewBorder,NormalFloat:Normal,@markup.raw.block.markdown:Normal"
                }
            end
        end)(),
        inlay_hint = {
            enabled = true
        },
        codelens = {
            enabled = true,
        },
        servers = {
            basedpyright = {
                enabled = false,
                settings = {
                    basedpyright = {
                        analysis = {
                            inlayHints = {
                                variableTypes = true,
                                callArgumentNames = true,
                                functionReturnTypes = true,
                                genericTypes = true,
                            },
                            diagnosticSeverityOverrides = {
                                reportWildcardImportFromLibrary = "none",
                                reportUntypedFunctionDecorator = "none",
                                reportUntypedClassDecorator = "none",
                                reportUntypedBaseClass = "none",
                                reportUntypedNamedTuple = "none",
                                reportUnknownParameterType = "none",
                                reportUnknownArgumentType = "none",
                                reportUnknownLambdaType = "none",
                                reportUnknownVariableType = "none",
                                reportUnknownMemberType = "none",
                                reportMissingParameterType = "none",
                                reportMissingTypeStubs = "none",
                                reportIncompleteStub = "none",
                                reportUnusedCallResult = "none",
                                reportUnannotatedClassAttribute = "none",
                                reportAny = "none",
                            }
                        }
                    }
                }
            },
            cmake = {
                enabled = true
            },
            clangd = {
                enabled = true,
                cmd = {
                    "clangd" .. (function()
                        if vim.fn.has("win32") == 1 then
                            return ".cmd"
                        else
                            return ""
                        end
                    end)(),
                    -- "--background-index",
                    -- "--header-insertion=never",
                    -- "--clang-tidy",
                    -- "--suggest-missing-includes",
                    -- "--completion-style=detailed",
                    -- "--function-arg-placeholders",
                    -- "--fallback-style=llvm"
                },
                capabilities = {
                    textDocument = {
                        sementicHighlighting = true,
                    },
                    offsetEncoding = 'utf-8'
                }
            },
            emmylua_ls = {
                enabled = true,
            },
            jsonls = {
                enabled = true,
            },
            lua_ls = {
                enabled = false,
                settings = {
                    Lua = {
                        completion = {
                            callSnippet = "Both"
                        },
                        hint = {
                            enable = true,
                            setType = true,
                        },
                        runtime = { version = "LuaJIT" },
                        codelens = {
                            enable = true,
                        }
                    }
                }
            },
            marksman = {
                enabled = true
            },
            matlab_ls = {
                enabled = true,
                filetypes = { "matlab" },
                settings = {
                    MATLAB = {
                        installPath = (function()
                            if vim.uv.os_uname().sysname == 'Windows_NT' then
                                return "C:\\Program Files\\MATLAB\\R2022b"
                            elseif vim.fn.has('wsl') == 1 then
                                return "/mnt/c/Program Files/MATLAB/R2022b"
                            end
                        end)()
                    }
                },
                single_file_support = true
            },
            nushell = {
                enabled = true
            },
            perlnavigator = {
                enabled = true
            },
            pyrefly = {
                enabled = false,
            },
            pyright = {
                enabled = false,
            },
            ruff = {
                enabled = true,
                init_options = {
                    settings = {
                        lint = {
                            ignore = {
                                "F405", -- 'F405: Name may be undefined, or defined from star imports: <module>'
                            }
                        }
                    }
                }
            },
            rust_analyzer = {
                enabled = false,
                filetypes = {}, -- Disable rust_analyzer for now, use rustaceanvim instead
                settings = {
                    ['rust_analyzer'] = {}
                }
            },
            ts_ls = {
                enabled = true
            },
            ty = {
                enabled = true,
                settings = {
                    ty = {
                        configuration = {
                            environment = {
                                python = vim.env.HOME .. "/.pixi/envs/default/bin/python"
                            },
                            -- src = {
                            --     include = {
                            --         vim.env.HOME .. "/.pixi/envs/default/lib/python3.13",
                            --         vim.env.HOME .. "/.pixi/envs/default/lib/python3.13/site-packages",
                            --         vim.env.HOME .. "/.pixi/envs/default/lib/python3.13/site-packages/torch",
                            --     }
                            -- }
                        },
                        -- importStrategy = "fromEnvironment",
                        diagnosticMode = "workspace",
                        experimental = {
                            rename = true,
                            autoImport = true,
                        },
                    },
                }
            },
            vimls = {
                enabled = true
            },
            yamlls = {
                enabled = true
            }
        }
    },
    config = function(_, opts)
        local lspconfig = require('lspconfig')

        if opts.diagnostic ~= nil then
            vim.diagnostic.config(opts.diagnostic)
            if opts.diagnostic.float.enabled then
                vim.cmd [[autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focus = false })]]
            end
        end

        -- local orig_open_float = vim.diagnostic.open_float
        -- vim.diagnostic.open_float = function(open_float_opts)
        --     local float_bufnr, win_id = orig_open_float(open_float_opts)
        --     if win_id ~= nil then
        --         if opts.diagnostic.float.winhighlight ~= nil then
        --             vim.api.nvim_set_option_value('winhighlight', opts.diagnostic.float.winhighlight, { win = win_id })
        --         end
        --         if opts.diagnostic.float.focusable ~= nil then
        --             vim.api.nvim_win_set_config(win_id, { focusable = opts.diagnostic.float.focusable })
        --         end
        --     end
        --     return float_bufnr, win_id
        -- end

        if opts.log_level ~= nil then
            vim.lsp.set_log_level(opts.log_level)
        end

        local orig_hover = vim.lsp.buf.hover
        vim.lsp.buf.hover = function (config)
            config = vim.tbl_deep_extend("force", config or {}, opts.hover)
            config.caller = "hover"
            return orig_hover(config)
        end

        -- local signature_win = nil
        -- local orig_signature_help = vim.lsp.buf.signature_help
        -- local orig_signature_help_handler = vim.lsp.handlers["textDocument/signatureHelp"]
        -- vim.lsp.buf.signature_help = function (config)
        --     return orig_signature_help(vim.tbl_deep_extend('force', config or {}, { caller = "signature_help", close_events = { "BufHidden", "InsertLeave" } }))
        -- end
        -- vim.lsp.handlers["textDocument/signatureHelp"] = function(err, result, ctx)
        --     if err or not result or not result.signatures or #result.signatures == 0 then
        --         if signature_win then
        --             vim.api.nvim_win_close(signature_win, true)
        --             signature_win = nil
        --         end
        --     else
        --         return orig_signature_help_handler(err, result, ctx)
        --     end
        -- end
        --
        -- vim.api.nvim_create_autocmd({ "CursorHoldI", "CursorMovedI", "InsertCharPre", "TextChangedI", "TextChangedP" }, {
        --     pattern = "*",
        --     callback = function ()
        --         vim.lsp.buf.signature_help({ focus = false, focusable = false, silent = true })
        --     end
        -- })

        local orig_open_floating_preview = vim.lsp.util.open_floating_preview
        vim.lsp.util.open_floating_preview = function(contents, syntax, opts_)
            opts_ = vim.tbl_deep_extend("force", opts_ or {}, opts.floating_preview)
            local float_bufnr, win_id = orig_open_floating_preview(contents, syntax, opts_)
            if win_id ~= nil then
                if opts_.winhighlight ~= nil then
                    vim.api.nvim_set_option_value('winhighlight', opts_.winhighlight, { win = win_id })
                end
                vim.api.nvim_set_option_value('filetype', 'markdown', { buf = float_bufnr })
                vim.api.nvim_set_option_value('conceallevel', 3, { win = win_id })
                if opts_.focusable ~= nil then
                    vim.api.nvim_win_set_config(win_id, { focusable = opts_.focusable })
                end
            end
            -- if opts_.caller == "signature_help" then
            --     signature_win = win_id
            -- end
            return float_bufnr, win_id
        end

        for server, server_opts in pairs(opts.servers) do
            server_opts = vim.tbl_deep_extend('force',
                {
                    capabilities = vim.tbl_deep_extend('force',
                        vim.lsp.protocol.make_client_capabilities(),
                        require('cmp_nvim_lsp').default_capabilities(),
                        server_opts.capabilities or {},
                        {
                            textDocument = {
                                foldingRange = {
                                    dynamicRegistration = false,
                                    lineFoldingOnly = true
                                }
                            }
                        }
                    )
                },
                server_opts
            )
            if opts.codelens.enabled then
                local orig_on_attach = server_opts.on_attach
                server_opts.on_attach = function(client, buffer)
                    if client.supports_method('textDocument/codeLens') then
                        vim.lsp.codelens.refresh()
                        vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost' }, {
                            buffer = buffer,
                            callback = vim.lsp.codelens.refresh
                        })
                    end
                    if orig_on_attach ~= nil then
                        orig_on_attach(client, buffer)
                    end
                end
            end
            vim.lsp.config(server, server_opts)
            if server_opts.enabled then
                vim.lsp.enable(server, true)
            end
        end

        if opts.inlay_hint.enabled ~= nil then
            vim.lsp.inlay_hint.enable(opts.inlay_hint.enabled)
        end

        local brglng = require("brglng")
        brglng.hl.transform_tbl(function ()
            local tbl = {
                LspDiagnosticFloatBorder = { fg = "FloatBorder.fg,Normal.fg", bg = "Normal.bg" },
                LspFloatingPreviewBorder = { fg = "FloatBorder.fg,Normal.fg", bg = "Normal.bg" },
                DiagnosticVirtualTextError = {
                    fg = "DiagnosticError.fg",
                    bg = { "blend", fg = "DiagnosticError.fg", bg = "Normal.bg", opacity = 0.1 }
                },
                DiagnosticVirtualTextWarn = {
                    fg = "DiagnosticWarn.fg",
                    bg = { "blend", fg = "DiagnosticWarn.fg", bg = "Normal.bg", opacity = 0.1 }
                },
                DiagnosticVirtualTextInfo = {
                    fg = "DiagnosticInfo.fg",
                    bg = { "blend", fg = "DiagnosticInfo.fg", bg = "Normal.bg", opacity = 0.1 }
                },
                DiagnosticVirtualTextHint = {
                    fg = "DiagnosticHint.fg",
                    bg = { "blend", fg = "DiagnosticHint.fg", bg = "Normal.bg", opacity = 0.1 }
                },
                DiagnosticVirtualLinesError = {
                    fg = "DiagnosticError.fg",
                    bg = { "blend", fg = "DiagnosticError.fg", bg = "Normal.bg", opacity = 0.1 }
                },
                DiagnosticVirtualLinesWarn = {
                    fg = "DiagnosticWarn.fg",
                    bg = { "blend", fg = "DiagnosticWarn.fg", bg = "Normal.bg", opacity = 0.1 }
                },
                DiagnosticVirtualLinesInfo = {
                    fg = "DiagnosticInfo.fg",
                    bg = { "blend", fg = "DiagnosticInfo.fg", bg = "Normal.bg", opacity = 0.1 }
                },
                DiagnosticVirtualLinesHint = {
                    fg = "DiagnosticHint.fg",
                    bg = { "blend", fg = "DiagnosticHint.fg", bg = "Normal.bg", opacity = 0.1 }
                },
            }
            return tbl
        end)

        -- Use LspAttach autocommand to only map the following keys
        -- after the language server attaches to the current buffer
        vim.api.nvim_create_autocmd('LspAttach', {
            group = vim.api.nvim_create_augroup('UserLspConfig', {}),
            callback = function(ev)
                -- Enable completion triggered by <c-x><c-o>
                vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

                -- Buffer local mappings.
                -- See `:help vim.lsp.*` for documentation on any of the below functions
                local opts = { buffer = ev.buf }
                vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
                vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
                -- vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
                vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
                vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, opts)
                -- vim.keymap.set('n', '<leader>xn', vim.lsp.buf.rename, opts)
                -- vim.keymap.set('n', '<Leader>wa', vim.lsp.buf.add_workspace_folder, opts)
                -- vim.keymap.set('n', '<Leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
                -- vim.keymap.set('n', '<Leader>wl', function()
                --     print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                -- end, opts)
                -- vim.keymap.set({'n', 'v'}, '<Leader>xf', function()
                --     vim.lsp.buf.format { async = true }
                -- end, opts)
                vim.keymap.set({'n', 'v'}, '<Leader>=', function()
                    vim.lsp.buf.format { async = true }
                end, vim.tbl_extend('force', opts, { desc = "Format Buffer" }))
            end
        })
    end,
    keys = {
        { "<Leader>la", vim.lsp.buf.code_action, desc = "Show Diagnostics" },
        { "<Leader>le", vim.diagnostic.open_float, desc = "Show Diagnostics" },
        { "<Leader>lf", function() vim.lsp.buf.format { async = true } end, desc = "Format Buffer" },
    }
}
