require("toggleterm").setup {
    shade_terminals = false
}

function _G.set_terminal_keymaps()
    local opts = {buffer = 0}
    vim.keymap.set('t', '<M-q>', [[<C-\><C-n>]], opts)
    vim.keymap.set('t', '<M-H>', [[<Cmd>wincmd h<CR>]], opts)
    vim.keymap.set('t', '<M-J>', [[<Cmd>wincmd j<CR>]], opts)
    vim.keymap.set('t', '<M-K>', [[<Cmd>wincmd k<CR>]], opts)
    vim.keymap.set('t', '<M-L>', [[<Cmd>wincmd l<CR>]], opts)
    vim.keymap.set('t', '<M-W>', [[<Cmd>wincmd w<CR>]], opts)
    vim.keymap.set('t', '<M-P>', [[<Cmd>wincmd p<CR>]], opts)
end

vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
