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
        -- "Exafunction/codeium.nvim",
        "MeanderingProgrammer/render-markdown.nvim",
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
            -- symbol_map = {
            --     Codeium = ""
            -- },
        }

        local has_words_before = function()
            unpack = unpack or table.unpack
            local line, col = unpack(vim.api.nvim_win_get_cursor(0))
            return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
        end

        local window_bordered = cmp.config.window.bordered()
        window_bordered.border = 'rounded'
        -- window_bordered.border = { '🭽', '▔', '🭾', '▕', '🭿', '▁', '🭼', '▏' }
        window_bordered.col_offset = -4
        window_bordered.side_padding = 1
        -- window_bordered.winhighlight = 'Normal:Pmenu,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None'
        -- window_bordered.winblend = 20

        local function set_cmp_colors()
            local colorutil = require('brglng.colorutil')
            local NormalFloat = vim.api.nvim_get_hl(0, { name = 'NormalFloat', link = false })
            local Comment = vim.api.nvim_get_hl(0, { name = 'Comment', link = false })
            local Pmenu = vim.api.nvim_get_hl(0, { name = 'Pmenu', link = false })
            local PmenuSel = vim.api.nvim_get_hl(0, { name = 'PmenuSel', link = false })
            local bg, sel_bg
            if vim.o.background == 'dark' then
                bg = colorutil.add_value(Pmenu.bg, 0.02)
                sel_bg = colorutil.add_value(PmenuSel.bg, 0.02)
            else
                bg = colorutil.reduce_value(Pmenu.bg, 0.02)
                sel_bg = colorutil.reduce_value(PmenuSel.bg, 0.02)
            end
            -- vim.api.nvim_set_hl(0, 'NormalFloat', { fg = NormalFloat.fg, bg = NormalFloat.bg })
            vim.api.nvim_set_hl(0, 'CmpItemMenu', { fg = Comment.fg, bg = nil })
            -- vim.api.nvim_set_hl(0, 'Pmenu', { bg = bg })
            -- vim.api.nvim_set_hl(0, 'PmenuSel', { bg = sel_bg })
            -- vim.api.nvim_set_hl(0, 'PmenuSbar', { bg = bg })
        end
        vim.api.nvim_create_autocmd('ColorScheme', { pattern = '*', callback = set_cmp_colors })
        vim.api.nvim_create_autocmd('OptionSet', { pattern = 'background', callback = set_cmp_colors })
        set_cmp_colors()

        cmp.setup {
            window = (function()
                if vim.g.neovide then
                    return {
                        completion = {
                            col_offset = -3,
                            side_padding = 1,
                        },
                    }
                else
                    return {
                        completion = window_bordered,
                        documentation = window_bordered,
                    }
                end
            end)(),
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
                            if string.sub(kind.menu or "", 1)== '(' then
                                kind.abbr = string.sub(vim.trim(kind.abbr or ""), 1, -2) .. vim.trim(kind.menu or "")
                            else
                                kind.abbr = vim.trim(kind.abbr or "") .. " " .. vim.trim(kind.menu or "")
                            end
                        else
                            if vim.trim(kind.abbr or "") == vim.trim(kind.menu or "") then
                                kind.abbr = vim.trim(kind.abbr or "")
                            else
                                kind.abbr = vim.trim(kind.abbr or "") .. " " ..  vim.trim(kind.menu or "")
                            end
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
                -- { name = "codeium" },
                { name = "async_path" },
                { name = "buffer" },
                { name = "render-markdown" }
            }),
            mapping = cmp.mapping.preset.insert({
                ['<C-x><C-x>'] = cmp.mapping.complete(),
                ['<Tab>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
                    elseif luasnip.locally_jumpable(1) then
                        luasnip.jump(1)
                    else
                        fallback()
                    end
                end, { 'i', 's' }),
                ['<S-Tab>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
                    elseif luasnip.locally_jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, { 'i', 's' }),
                ["<CR>"] = cmp.mapping(function(fallback)
                    if cmp.visible() and cmp.get_active_entry() then
                        cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
                    else
                        fallback()
                    end
                end, { "i", "s", "c" }),
                ["<C-n>"] = cmp.mapping({
                    i = function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
                        else
                            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Down>', true, true, true), 'i', true)
                        end
                    end,
                }),
                ["<C-p>"] = cmp.mapping({
                    i = function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
                        else
                            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Up>', true, true, true), 'i', true)
                        end
                    end,
                }),
                ['<C-u>'] = cmp.mapping.scroll_docs(-4), -- Up
                ['<C-d>'] = cmp.mapping.scroll_docs(4),  -- Down
                ['<C-j>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert, count = 10 }),
                ['<C-k>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert, count = 10 }),
                ['<C-e>'] = cmp.mapping({
                    i = function(fallback)
                        if cmp.visible() then
                            cmp.abort()
                        else
                            if vim.fn.col('.') > vim.fn.strlen(vim.fn.getline('.')) then
                                fallback()
                            else
                                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<End>', true, true, true), 'i', true)
                            end
                        end
                    end,
                    c = function(fallback)
                        if cmp.visible() then
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
                -- { name = "codeium" },
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
                -- { name = "codeium" },
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
                -- { name = "codeium" },
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
