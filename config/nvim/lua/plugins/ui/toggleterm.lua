return {
    'akinsho/toggleterm.nvim',
    version = "*",
    event = "VeryLazy",
    opts = {
        size = function(term)
            if term.direction == "horizontal" then
                return vim.o.lines * 0.4
            else
                return vim.o.columns * 0.4
            end
        end,
        hide_numbers = false,
        shade_terminals = false,
        start_in_insert = true,
        shell = (function()
            if vim.fn.executable('nu') then
                return vim.fn.exepath('nu')
            elseif vim.fn.executable('zsh') then
                return vim.fn.exepath('zsh')
            else
                return vim.fn.exepath('bash')
            end
        end)(),
        winbar = {
            enabled = false,
            name_formatter = function(term)
                return ' ' .. term.name
            end
        }
    },
    config = function (_, opts)
        require("toggleterm").setup(opts)

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
    end,
    keys = {
        { "<M-=>", "<Cmd>SidebarToggle terminal<CR>", mode = { "n", "i", "t" }, desc = "Terminal" },
    }
}
