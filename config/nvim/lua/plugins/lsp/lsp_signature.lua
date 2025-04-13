return {
    "ray-x/lsp_signature.nvim",
    enabled = true,
    cond = false,
    event = { "LspAttach" },
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
                    return "none"
                else
                    -- return { '🭽', '▔', '🭾', '▕', '🭿', '▁', '🭼', '▏' }
                    return "rounded"
                end
            end)(),
            focusable = true,
            winhighlight = (function()
                if not vim.g.neovide then
                    return 'FloatBorder:LspSignatureFloatBorder,NormalFloat:Normal'
                end
            end)()
        },
        -- transparency = 20,
        hint_enable = false,
        -- padding = " "
    },
    config = function(_, opts)
        require("lsp_signature").setup(opts)
    end
}
