return {
    "ray-x/lsp_signature.nvim",
    enabled = true,
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    dependencies = { "neovim/nvim-lspconfig" },
    opts = {
        bind = true,
        doc_lines = 50,
        wrap = true,
        max_height = 50,
        max_width = 120,
        floating_window_off_x = 0,
        floating_window_off_y = 0,
        handler_opts = {
            border = (function()
                if vim.g.neovide then
                    return "solid"
                else
                    -- return { '🭽', '▔', '🭾', '▕', '🭿', '▁', '🭼', '▏' }
                    return "solid"
                end
            end)(),
            focusable = true,
            winhighlight = 'FloatBorder:LspSignatureFloatBorder'
        },
        -- transparency = 20,
        hint_enable = false,
        padding = " "
    },
    config = function(_, opts)
        require("lsp_signature").setup(opts)
        local orig_open_floating_preview = vim.lsp.util.open_floating_preview
        vim.lsp.util.open_floating_preview = function(contents, syntax, opts_)
            local float_bufnr, win_id = orig_open_floating_preview(contents, syntax, opts_)
            if win_id ~= nil then
                if opts.handler_opts.winhighlight ~= nil then
                    vim.api.nvim_set_option_value('winhighlight', opts.handler_opts.winhighlight, { win = win_id })
                end
                vim.api.nvim_set_option_value('filetype', 'markdown', { buf = float_bufnr })
                vim.api.nvim_set_option_value('conceallevel', 3, { win = win_id })
                if opts.handler_opts.focusable ~= nil then
                    vim.api.nvim_win_set_config(win_id, { focusable = opts.handler_opts.focusable })
                end
            end
            return float_bufnr, win_id
        end
        local set_lsp_signature_colors = function()
            local colorutil = require('brglng.colorutil')
            local Normal = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
            local NormalFloat = vim.api.nvim_get_hl(0, { name = "NormalFloat", link = false })
            local WinSeparator = vim.api.nvim_get_hl(0, { name = "WinSeparator", link = false })
            local border_fg
            if vim.o.background == 'dark' then
                border_fg = colorutil.reduce_value(Normal.bg, 0.005)
            else
                border_fg = colorutil.transparency(WinSeparator.fg, Normal.bg, 0.2)
            end
            vim.api.nvim_set_hl(0, "LspSignatureFloatBorder", {
                fg = border_fg,
                bg = NormalFloat.bg,
            })
        end
        vim.api.nvim_create_autocmd("ColorScheme", {
            pattern = "*",
            callback = set_lsp_signature_colors
        })
        vim.api.nvim_create_autocmd("OptionSet", {
            pattern = "background",
            callback = set_lsp_signature_colors
        })
    end
}
