return {
    "kevinhwang91/nvim-ufo",
    dependencies = {
        "kevinhwang91/promise-async",
        'nvim-treesitter/nvim-treesitter',
    },
    event = { "BufReadPost", "BufWritePost", "BufNewFile", "LspAttach" },
    init = function()
        vim.o.foldcolumn = "1" -- '0' is not bad
        vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
        vim.o.foldlevelstart = 99
        vim.o.foldenable = true
    end,
    config = function ()
        require('ufo').setup({
            provider_selector = function(bufnr, filetype, buftype)
                return {'treesitter', 'indent'}
            end,
            disabled = { "neo-tree" }
        })

        vim.o.foldmethod = "expr"
        vim.o.foldexpr = "nvim_treesitter#foldexpr()"
        vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
        -- vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep:│,foldclose:]]
        -- vim.o.fillchars = [[eob: ,fold: ,foldopen:󰛲,foldsep:│,foldclose:󰜄]]

        vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
        vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)

        vim.api.nvim_create_autocmd('FileType', {
            pattern = { 'neo-tree' },
            callback = function()
                require('ufo').detach()
                vim.opt_local.foldenable = false
                vim.opt_local.foldcolumn = '0'
            end,
        })
    end
}
