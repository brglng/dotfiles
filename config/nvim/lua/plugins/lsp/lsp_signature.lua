return {
    "ray-x/lsp_signature.nvim",
    enabled = true,
    lazy = true,
    event = "VeryLazy",
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
            border = "rounded",
            -- border = { '🭽', '▔', '🭾', '▕', '🭿', '▁', '🭼', '▏' },
            focusable = true,
            -- winhighlight = 'NormalFloat:Normal'
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
    end
}
