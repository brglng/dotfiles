return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    dependencies = {
        "hrsh7th/nvim-cmp",
        "ray-x/lsp_signature.nvim",
        "folke/neoconf.nvim",
        "p00f/clangd_extensions.nvim"
    },
    opts = {
        -- log_level = 'debug'

        diagnostic = {
            virtual_text = false,
            float = {
                border = "rounded",
                -- border = {
                --     { " ", "NormalFloat" },
                --     { " ", "NormalFloat" },
                -- }
                -- border = { '🭽', '▔', '🭾', '▕', '🭿', '▁', '🭼', '▏' }
                focusable = false,
                -- winhighlight = 'NormalFloat:Normal'
            }
        },

        inlay_hint = {
            enabled = true
        },
        codelens = {
            enabled = true,
        },
        servers = {
            clangd = {
                cmd = {
                    "clangd",
                    "--background-index",
                    "--header-insertion=never",
                    "--clang-tidy",
                    "--suggest-missing-includes",
                    "--completion-style=detailed",
                    "--function-arg-placeholders",
                    "--fallback-style=llvm"
                },
                capabilities = {
                    textDocument = {
                        sementicHighlighting = true,
                    },
                    offsetEncoding = 'utf-8'
                }
            },
            lua_ls = {},
            -- lua_ls = {
            --     cmd = { "lua-language-server", "--logpath=" .. vim.fn.stdpath("log") .. "/luals" },
            --     on_init = function(client)
            --         local path = client.workspace_folders[1].name
            --         if not vim.uv.fs_stat(path .. '/.luarc.json') and not vim.loop.fs_stat(path .. '/.luarc.jsonc') then
            --             client.config.settings = vim.tbl_deep_extend('force', client.config.settings, {
            --                 Lua = {
            --                     runtime = {
            --                         -- Tell the language server which version of Lua you're using
            --                         -- (most likely LuaJIT in the case of Neovim)
            --                         version = 'LuaJIT'
            --                     },
            --                     -- Make the server aware of Neovim runtime files
            --                     workspace = {
            --                         checkThirdParty = false,
            --                         -- library = {
            --                         --     vim.env.VIMRUNTIME
            --                         --     -- "${3rd}/luv/library"
            --                         --     -- "${3rd}/busted/library",
            --                         -- }
            --                         -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
            --                         library = vim.api.nvim_get_runtime_file("", true)
            --                     }
            --                 }
            --             })
            --             client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
            --         end
            --         return true
            --     end,
            -- },
            nushell = {},
            pyright = {},
            tsserver = {},
            -- rust_analyzer = {
            --     settings = {
            --         ['rust_analyzer'] = {}
            --     }
            -- },
            vimls = {}
        }
    },
    config = function(_, opts)
        local lspconfig = require('lspconfig')

        if opts.diagnostic ~= nil then
            vim.diagnostic.config(opts.diagnostic)
        end
        local orig_open_float = vim.diagnostic.open_float
        vim.diagnostic.open_float = function(open_float_opts)
            local float_bufnr, win_id = orig_open_float(open_float_opts)
            if win_id ~= nil then
                if opts.diagnostic.float.winhighlight ~= nil then
                    vim.api.nvim_set_option_value('winhighlight', opts.diagnostic.float.winhighlight, { win = win_id })
                end
                if opts.diagnostic.float.focusable ~= nil then
                    vim.api.nvim_win_set_config(win_id, { focusable = opts.diagnostic.float.focusable })
                end
            end
            return float_bufnr, win_id
        end

        if opts.log_level ~= nil then
            vim.lsp.set_log_level(opts.log_level)
        end

        if opts.inlay_hint.enabled ~= nil then
            vim.lsp.inlay_hint.enable(opts.inlay_hint.enabled)
        end

        -- vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
        --     vim.lsp.handlers.hover, {
        --         border = "none",
        --         -- border = "rounded",
        --         -- border = {
        --         --     { " ", "NormalFloat" },
        --         --     { " ", "NormalFloat" },
        --         -- },
        --         silent = false
        --     }
        -- )
        -- vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
        --     vim.lsp.handlers.signature_help, {
        --         border = "rounded",
        --         silent = false,
        --         focusable = false
        --     }
        -- )

        for server, server_opts in pairs(opts.servers) do
            server_opts = vim.tbl_deep_extend('force',
                {
                    capabilities = vim.tbl_deep_extend('force',
                        vim.lsp.protocol.make_client_capabilities(),
                        require('cmp_nvim_lsp').default_capabilities(),
                        server_opts.capabilities or {}
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
            lspconfig[server].setup(server_opts)
        end

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
                vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
                vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
                vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
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
                end, opts)
            end
        })
    end,
    keys = {
        { '<Leader>e', mode = { 'n' }, vim.diagnostic.open_float, desc = 'Show Diagnostic' },
        { '[d', mode = { 'n' }, vim.diagnostic.goto_prev, desc = 'Previous Diagnostic' },
        { ']d', mode = { 'n' }, vim.diagnostic.goto_next, desc = 'Next Diagnostic' }
    }
}
