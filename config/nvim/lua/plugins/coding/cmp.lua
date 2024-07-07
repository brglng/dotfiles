return {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
        "neovim/nvim-lspconfig",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-nvim-lua",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/cmp-omni",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "petertriho/cmp-git",
        "davidsierradz/cmp-conventionalcommits",
        "FelipeLema/cmp-async-path",
        "onsails/lspkind.nvim",
        {
            "Exafunction/codeium.nvim",
            dependencies = {
                "nvim-lua/plenary.nvim"
            }
        },
    },
    enabled = true,
    config = function ()
        local cmp = require('cmp')
        local types = require("cmp.types")
        local str = require("cmp.utils.str")
        local cmp_autopairs = require('nvim-autopairs.completion.cmp')

        local luasnip = require('luasnip')

        local lspkind = require('lspkind')
        lspkind.init {
            symbol_map = {
                Codeium = ""
            },
        }
        require("codeium").setup {}

        local has_words_before = function()
            unpack = unpack or table.unpack
            local line, col = unpack(vim.api.nvim_win_get_cursor(0))
            return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
        end

        local window_bordered = cmp.config.window.bordered()
        window_bordered.border = 'rounded'
        window_bordered.col_offset = -4
        window_bordered.side_padding = 1
        -- window_bordered.winblend = 20
        vim.cmd [[ autocmd ColorScheme * highlight! link CmpItemMenu Comment ]]
        vim.cmd [[ autocmd OptionSet background highlight! link CmpItemMenu Comment ]]
        cmp.setup {
            window = {
                -- completion = {
                --     col_offset = -3,
                --     side_padding = 1
                -- },
                completion = window_bordered,
                documentation = window_bordered,
            },
            -- view = {
            --     entries = {
            --         follow_cursor = true,
            --     }
            -- },
            formatting = {
                fields = {
                    cmp.ItemField.Kind,
                    cmp.ItemField.Abbr,
                    cmp.ItemField.Menu,
                },
                format = lspkind.cmp_format({
                    mode = "symbol_text",
                    maxwidth = 50,
                    ellipsis_char = '…',
                    before = function(entry, vim_item)
                        local kind = require("lspkind").cmp_format({
                            mode = "symbol_text",
                            maxwidth = 50,
                            ellipsis_char = '…',
                            show_labelDetails = true
                        })(entry, vim_item)
                        -- if string.sub(vim.fn.mode(), 1, 1) == "c" then
                        --     cmp.setup({ window = { completion = { side_padding = 0, col_offset = -3 } } })
                        -- else
                        --     cmp.setup({ window = { completion = { side_padding = 0, col_offset = -3 } } })
                        -- end
                        local strings = vim.split(kind.kind, "%s", { trimempty = true })
                        kind.kind = vim.trim(strings[1]) or ""
                        if string.sub(kind.abbr or "", -1) == "~" and (kind.menu or "") ~= "" then
                            kind.abbr = string.sub(vim.trim(kind.abbr or ""), 1, -2) .. vim.trim(kind.menu or "")
                        else
                            kind.abbr = vim.trim(kind.abbr or "") .. vim.trim(kind.menu or "")
                        end
                        kind.menu = vim.trim(strings[2]) or ""
                        return kind
                    end
                })
            },
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body) -- For `luasnip` users.
                end,
            },
            sources = cmp.config.sources({
                { name = "nvim_lsp" },
                { name = "luasnip" },
                {
                    name = 'omni',
                    option = {
                        disable_omnifuncs = { 'v:lua.vim.lsp.omnifunc' }
                    }
                },
                { name = "codeium" },
                { name = "async_path" },
                { name = "buffer" },
            }),
            mapping = cmp.mapping.preset.insert({
                ['<C-x><C-x>'] = cmp.mapping.complete(),
                ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
                ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
                -- ['<C-n>'] = cmp.mapping({
                --     i = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
                --     c = cmp.config.disable,
                -- }),
                -- ['<C-p>'] = cmp.mapping({
                --     i = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
                --     c = cmp.config.disable,
                -- }),
                ['<C-u>'] = cmp.mapping.scroll_docs(-4), -- Up
                ['<C-d>'] = cmp.mapping.scroll_docs(4),  -- Down
                ['<C-j>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert, count = 10 }),
                ['<C-k>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert, count = 10 }),
                ['<C-e>'] = cmp.mapping({
                    i = function(fallback)
                        if cmp.visible() and cmp.get_active_entry() then
                            cmp.abort()
                        else
                            if vim.fn.col('.') > vim.fn.strlen(vim.fn.getline('.')) then
                                fallback()
                            else
                                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<End>', true, true, true), 'n', true)
                            end
                        end
                    end,
                    c = function(fallback)
                        if cmp.visible() and cmp.get_active_entry() then
                            cmp.abort()
                        else
                            if vim.fn.getcmdpos() > vim.fn.strlen(vim.fn.getcmdline()) then
                                fallback()
                            else
                                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<End>', true, true, true), 'n', true)
                            end
                        end
                    end
                }),
                ["<CR>"] = cmp.mapping({
                    i = function(fallback)
                        if cmp.visible() and cmp.get_active_entry() then
                            cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
                        else
                            fallback()
                        end
                    end,
                    c = function(fallback)
                        if cmp.visible() and cmp.get_active_entry() then
                            cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
                        else
                            fallback()
                        end
                    end,
                    s = function(fallback)
                        if cmp.visible() and cmp.get_active_entry() then
                            cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
                        else
                            fallback()
                        end
                    end,
                }),
                ['<Tab>'] = cmp.mapping(function(fallback)
                    if luasnip.expand_or_jumpable() then
                        luasnip.expand_or_jump()
                    else
                        fallback()
                    end
                end, { 'i', 's' }),
                ['<S-Tab>'] = cmp.mapping(function(fallback)
                    if luasnip.jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, { 'i', 's' }),
            }),
            experimental = {
                ghost_text = false,
            }
        }
        cmp.setup.filetype('gitcommit', {
            sources = cmp.config.sources({
                { name = "conventionalcommits" },
                { name = "async_path" },
                { name = 'git' },
                { name = "codeium" },
                { name = 'buffer' },
            })
        })
        cmp.setup.filetype("lua", {
            sources = cmp.config.sources({
                { name = "lazydev", group_index = 0 },
                { name = "nvim_lua" },
                { name = "nvim_lsp" },
                {
                    name = "omni",
                    option = {
                        disable_omnifuncs = { "v:lua.vim.lsp.omnifunc" }
                    }
                },
                { name = "codeium" },
                { name = "async_path" },
                { name = "buffer" }
            })
        })
        cmp.setup.filetype("toml", {
            sources = cmp.config.sources(
                { name = "nvim_lsp" },
                {
                    name = "omni",
                    option = {
                        disable_omnifuncs = { "v:lua.vim.lsp.omnifunc" }
                    }
                },
                { name = "crates" },
                { name = "codeium" },
                { name = "async_path" },
                { name = "buffer" }
            )
        })
        -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
        cmp.setup.cmdline({ '/', '?' }, {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
                { name = 'buffer' }
            }
        })

        -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
        cmp.setup.cmdline(':', {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({
                { name = 'async_path' }
            }, {
                { name = 'cmdline' }
            })
        })

        cmp.event:on(
            'confirm_done',
            cmp_autopairs.on_confirm_done()
        )
    end
}
