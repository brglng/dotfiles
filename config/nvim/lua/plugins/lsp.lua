require("mason").setup()
require("mason-lspconfig").setup {
    ensure_installed = { "bashls", "clangd", "cmake", "lua_ls", "marksman", "pyright", "rust_analyzer", "tsserver", "vimls" }
}
local cmp_capabilities = require('cmp_nvim_lsp').default_capabilities()

local lspconfig = require('lspconfig')
-- vim.lsp.set_log_level("debug")

local clangd_capabilities = cmp_capabilities
clangd_capabilities.textDocument.semanticHighlighting = true
clangd_capabilities.offsetEncoding = "utf-8"

require("clangd_extensions").setup {
    inlay_hints = {
        only_current_line = true
    }
}

lspconfig.clangd.setup {
    capabilities = cmp_capabilities,
    cmd = { "clangd", "--background-index", "--header-insertion=never", "--clang-tidy", "--suggest-missing-includes", "--completion-style=detailed" },
    on_attach = function (args)
        require("clangd_extensions.inlay_hints").setup_autocmd()
        require("clangd_extensions.inlay_hints").set_inlay_hints()
    end
}
lspconfig.pyright.setup {
    capabilities = cmp_capabilities
}
lspconfig.tsserver.setup {
    capabilities = cmp_capabilities
}
lspconfig.rust_analyzer.setup {
    capabilities = cmp_capabilities,
    settings = {
        ['rust-analyzer'] = {},
    },
}
lspconfig.lua_ls.setup {
    capabilities = cmp_capabilities,
    cmd = { "lua-language-server", "--logpath=" .. vim.fn.stdpath("log") .. "/luals" },
    on_init = function(client)
        local path = client.workspace_folders[1].name
        if not vim.loop.fs_stat(path .. '/.luarc.json') and not vim.loop.fs_stat(path .. '/.luarc.jsonc') then
            client.config.settings = vim.tbl_deep_extend('force', client.config.settings, {
                Lua = {
                    runtime = {
                        -- Tell the language server which version of Lua you're using
                        -- (most likely LuaJIT in the case of Neovim)
                        version = 'LuaJIT'
                    },
                    -- Make the server aware of Neovim runtime files
                    workspace = {
                        checkThirdParty = false,
                        -- library = {
                        --     vim.env.VIMRUNTIME
                        --     -- "${3rd}/luv/library"
                        --     -- "${3rd}/busted/library",
                        -- }
                        -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
                        library = vim.api.nvim_get_runtime_file("", true)
                    }
                }
            })
            client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
        end
        return true
    end
}
lspconfig.vimls.setup {}

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<Leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)

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
