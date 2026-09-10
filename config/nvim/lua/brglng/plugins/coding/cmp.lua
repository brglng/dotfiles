return {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
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
        { "xzbdmw/colorful-menu.nvim", opts = {} },
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

        -- Read a module-local upvalue by name (private API), searching transitively through
        -- function-valued upvalues. Neovim's native on-type formatting module only exposes
        -- `enable()` publicly, so its internals are reachable only via upvalue chains.
        local function find_named_upvalue(fn, name, depth, seen)
            if type(fn) ~= 'function' or (depth or 0) > 8 then return nil end
            seen = seen or {}
            if seen[fn] then return nil end
            seen[fn] = true
            local i = 1
            while true do
                local upname, value = debug.getupvalue(fn, i)
                if upname == nil then return nil end
                if upname == name then return value end
                if type(value) == 'function' then
                    local found = find_named_upvalue(value, name, (depth or 0) + 1, seen)
                    if found ~= nil then return found end
                end
                i = i + 1
            end
        end

        -- Manually trigger native LSP on-type formatting after a manually inserted <CR> by
        -- reusing the internal pipeline of vim.lsp.on_type_formatting instead of hand-rolling
        -- textDocument/onTypeFormatting requests: its `format_iter` builds the standard params,
        -- requests per client and applies edits with the buffer-version guard. Trigger-character
        -- registration is intentionally left untouched: the native module's trigger table and
        -- vim.on_key listener are never engaged, so this cannot interfere with the cmp <CR>
        -- mapping or with the configured on_type_formatting triggers.
        local function trigger_native_on_type_formatting()
            local otf = vim.lsp.on_type_formatting
            if type(otf) ~= 'table' or type(otf.enable) ~= 'function' then return end

            -- The native on_key normalizes typed '\r' to '\n'; the LSP expects '\n' as `ch`.
            local format_iter = find_named_upvalue(otf.enable, 'format_iter')
            if type(format_iter) ~= 'function' then return end

            local bufnr = vim.api.nvim_get_current_buf()
            -- get_clients({ method = ... }) already applies supports_method for this buffer.
            local clients = vim.lsp.get_clients({ bufnr = bufnr, method = 'textDocument/onTypeFormatting' })
            if #clients == 0 then return end

            local triggered_clients = {}
            for _, client in ipairs(clients) do
                local provider = client.server_capabilities
                    and client.server_capabilities.documentOnTypeFormattingProvider
                local native_newline_trigger = provider
                    and (provider.firstTriggerCharacter == '\n'
                        or vim.tbl_contains(provider.moreTriggerCharacter or {}, '\n')
                        or provider.firstTriggerCharacter == '\r'
                        or vim.tbl_contains(provider.moreTriggerCharacter or {}, '\r'))
                -- If native on-type formatting is enabled for this client and it already
                -- handles newline, vim.on_key() has scheduled the native request before cmp.
                -- Avoid sending the same request a second time from this mapping.
                if not (client._otf_enabled and native_newline_trigger) then
                    triggered_clients[client.id] = client
                end
            end
            if not next(triggered_clients) then return end
            -- Mirrors the native on_key schedule: format_iter(bufnr, typed, clients, next(clients)).
            format_iter(bufnr, '\n', triggered_clients, next(triggered_clients))
        end

        cmp.setup {
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
                    -- local lspkind = {
                    --     -- if you change or add symbol here
                    --     -- replace corresponding line in readme
                    --     Text = { "󰉿", "Normal" },
                    --     Method = { "󰆧", "@lsp.type.method" },
                    --     Function = { "󰊕", "lsp.type.function" },
                    --     Constructor = { "", "lsp.type.method" },
                    --     Field = { "󰜢", "@lsp.type.property" },
                    --     Variable = { "󰀫", "@lsp.type.variable" },
                    --     Class = { "󰠱", "@lsp.type.class" },
                    --     Interface = { "", "@lsp.type.interface" },
                    --     Module = { "", "@lsp.type.namespace" },
                    --     Property = { "󰜢", "@lsp.type.property" },
                    --     Unit = { "󰑭", "@lsp.type.type" },
                    --     Value = { "󰎠", "@lsp.type.number" },
                    --     Enum = { "", "@lsp.type.enum" },
                    --     Keyword = { "󰌋", "@lsp.type.keyword" },
                    --     Snippet = { "", "@lsp.type.macro" },
                    --     Color = { "󰏘", "@lsp.type.number" },
                    --     File = { "󰈙", "Normal" },
                    --     Reference = { "󰈇", "Normal" },
                    --     Folder = { "󰉋", "Directory" },
                    --     EnumMember = { "", "@lsp.type.enumMember" },
                    --     Constant = { "󰏿", "Constant" },
                    --     Struct = { "󰙅", "@lsp.type.struct" },
                    --     Event = { "", "@lsp.type.event" },
                    --     Operator = { "󰆕", "@lsp.type.operator" },
                    --     TypeParameter = { "", "@lsp.type.typeParameter" },
                    -- }
                    -- local icon = lspkind[vim_item.kind][1]
                    -- local icon_hl = lspkind[vim_item.kind][2]

                    local icon, icon_hl, _ = MiniIcons.get('lsp', vim_item.kind)

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
                    if cmp.visible() and cmp.get_selected_entry() then
                        cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
                    elseif luasnip.locally_jumpable(1) then
                        luasnip.jump(1)
                    elseif require("copilot.suggestion").is_visible() then
                        require("copilot.suggestion").accept()
                    -- elseif require("minuet.virtualtext").action.is_visible() then
                    --     require("minuet.virtualtext").action.accept()
                    -- elseif require("codeium.virtual_text").get_current_completion_item() then
                    --     vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Plug>(CodeiumAccept)", true, true, true), "n ", false)
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
                    if cmp.visible() and cmp.get_selected_entry() then
                        cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
                    elseif vim.api.nvim_get_mode().mode == 'i' and vim.fn.col('.') > vim.fn.strlen(vim.fn.getline('.')) then
                        fallback()
                        -- Match native timing: request only after the inserted newline has been
                        -- processed (didChange flushed, cursor settled on the new line).
                        vim.schedule(trigger_native_on_type_formatting)
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
                        elseif require("copilot.suggestion").is_visible() then
                            require("copilot.suggestion").accept_line()
                        -- elseif require("minuet.virtualtext").action.is_visible() then
                        --     require("minuet.virtualtext").action.accept_line()
                        -- elseif require("codeium.virtual_text").get_current_completion_item() then
                        --     vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Plug>(CodeiumAcceptLine)", true, true, true), "n ", false)
                        elseif vim.fn.col('.') > vim.fn.strlen(vim.fn.getline('.')) then
                            fallback()
                        else
                            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<End>', true, true, true), 'n', true)
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
                -- ['<Esc>'] = cmp.mapping({
                --     i = function(fallback)
                --         if cmp.visible() then
                --             cmp.abort()
                --         elseif require("copilot.suggestion").is_visible() then
                --             require("copilot.suggestion").dismiss()
                --         else
                --             fallback()
                --         end
                --     end,
                --     c = function(fallback)
                --         if cmp.visible() then
                --             cmp.abort()
                --         else
                --             vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-c>', true, true, true), 'c', true)
                --         end
                --     end
                -- }),
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
                CmpDocNormal = { fg = "NormalFloat.fg,Normal.fg", bg = "Normal.bg" },
                CmpDocBorder = { fg = "FloatBorder.fg,NormalFloat.fg,Normal.fg", bg = "Normal.bg" },
            }
        end
    end
}
