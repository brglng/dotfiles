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
        "xzbdmw/colorful-menu.nvim",
        "MeanderingProgrammer/render-markdown.nvim",
    },
    enabled = true,
    config = function ()
        local cmp = require('cmp')
        -- local cmp_autopairs = require('nvim-autopairs.completion.cmp')
        local luasnip = require('luasnip')

        local has_words_before = function()
            unpack = unpack or table.unpack
            local line, col = unpack(vim.api.nvim_win_get_cursor(0))
            return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
        end

        cmp.setup {
            preselect = cmp.PreselectMode.None,
            window = {
                completion = cmp.config.window.bordered({
                    border = (function()
                        if vim.g.neovide then
                            return "none"
                            -- return { '🭽', '▔', '🭾', '▕', '🭿', '▁', '🭼', '▏' }
                        else
                            return "rounded"
                        end
                    end)(),
                    col_offset = (function() if vim.g.neovide then return -3 else return -4 end end)(),
                    side_padding = 1,
                    winhighlight = 'Normal:CmpNormal,NormalFloat:CmpNormal,FloatBorder:CmpBorder,CursorLine:PmenuSel',
                }),
                documentation = cmp.config.window.bordered({
                    border = (function()
                        if vim.g.neovide then
                            -- return "none"
                            return { '', '', '', ' ', '', '', '', ' ' }
                        else
                            return "rounded"
                        end
                    end)(),
                    side_padding = 1,
                    winhighlight = 'Normal:CmpDocNormal,NormalFloat:CmpDocNormal,FloatBorder:CmpDocBorder',
                })
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
                format = function(entry, vim_item)
                    local icon, icon_hl, _ = MiniIcons.get('lsp', vim_item.kind)
                    -- if string.sub(vim_item.abbr or "", -1) == "~" and (vim_item.menu or "") ~= "" then
                    --     if string.sub(vim_item.menu or "", 1)== '(' then
                    --         vim_item.abbr = string.sub(vim.trim(vim_item.abbr or ""), 1, -2) .. vim.trim(vim_item.menu or "")
                    --     else
                    --         vim_item.abbr = vim.trim(vim_item.abbr or "") .. " " .. vim.trim(vim_item.menu or "")
                    --     end
                    -- else
                    --     if vim.trim(vim_item.abbr or "") == vim.trim(vim_item.menu or "") then
                    --         vim_item.abbr = vim.trim(vim_item.abbr or "")
                    --     else
                    --         vim_item.abbr = vim.trim(vim_item.abbr or "") .. " " ..  vim.trim(vim_item.menu or "")
                    --     end
                    -- end
                    vim_item.menu = "  " .. (vim_item.kind or "")
                    vim_item.kind = icon
                    vim_item.kind_hl_group = icon_hl

                    local highlights_info = require("colorful-menu").cmp_highlights(entry)

                    -- if highlight_info==nil, which means missing ts parser, let's fallback to use default `vim_item.abbr`.
                    -- What this plugin offers is two fields: `vim_item.abbr_hl_group` and `vim_item.abbr`.
                    if highlights_info ~= nil then
                        vim_item.abbr_hl_group = highlights_info.highlights
                        vim_item.abbr = highlights_info.text
                    end

                    vim_item.abbr = " " .. vim.trim(vim_item.abbr or "")

                    return vim_item
                end
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
                { name = "async_path" },
                { name = "buffer" },
                { name = "render-markdown" }
            }),
            mapping = cmp.mapping.preset.insert({
                ['<C-x><C-x>'] = cmp.mapping.complete(),
                ['<Tab>'] = cmp.mapping(function(fallback)
                    if luasnip.locally_jumpable(1) then
                        luasnip.jump(1)
                    else
                        fallback()
                    end
                end, { 'i', 's' }),
                ['<S-Tab>'] = cmp.mapping(function(fallback)
                    if luasnip.locally_jumpable(-1) then
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
                            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Down>', true, true, true), 'n', true)
                        end
                    end,
                }),
                ["<C-p>"] = cmp.mapping({
                    i = function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
                        else
                            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Up>', true, true, true), 'n', true)
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
                                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<End>', true, true, true), 'n', true)
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

        -- cmp.event:on(
        --     'confirm_done',
        --     cmp_autopairs.on_confirm_done()
        -- )

        local brglng = require("brglng")
        if vim.g.neovide then
            brglng.hl.transform_tbl {
                CmpNormal = { fg = "NormalFloat.fg,Normal.fg", bg = "NormalFloat.bg,Normal.bg" },
                CmpBorder = { fg = "FloatBorder.fg,NormalFloat.fg,Normal.fg", bg = "NormalFloat.bg,Normal.bg" },
                CmpItemMenu = { fg = "Comment.fg", bg = nil },
                CmpDocNormal = { fg = "NormalFloat.fg,Normal.fg", bg = { "lighten", from = "NormalFloat.bg,Normal.bg", amount = 0.04 } },
                CmpDocBorder = { fg = "FloatBorder.fg,NormalFloat.fg,Normal.fg", bg = "NormalFloat.bg,Normal.bg" },
            }
        else
            brglng.hl.transform_tbl {
                CmpNormal = { fg = "NormalFloat.fg,Normal.fg", bg = "Normal.bg" },
                CmpBorder = { fg = "FloatBorder.fg,NormalFloat.fg,Normal.fg", bg = "Normal.bg" },
                CmpItemMenu = { fg = "Comment.fg", bg = nil },
                PmenuThumb = { fg = "PmenuThumb.fg,Pmenu.fg", bg = "FloatBorder.fg" },
                CmpDocNormal = { fg = "NormalFloat.fg,Normal.fg", bg = "Normal.bg" },
                CmpDocBorder = { fg = "FloatBorder.fg,NormalFloat.fg,Normal.fg", bg = "Normal.bg" },
            }
        end
    end
}
