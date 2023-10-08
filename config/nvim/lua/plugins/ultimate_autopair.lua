-- local ua_core = require('ultimate-autopair.core')
-- local ua = require('ultimate-autopair')
-- local key_cr = vim.api.nvim_replace_termcodes("<CR>", true, true, true)
-- local key_c_g = vim.api.nvim_replace_termcodes("<C-g>", true, true, true)
-- local key_c_r = vim.api.nvim_replace_termcodes("<C-r>", true, true, true)
-- ua_core.dont_map = {key_cr}
-- ua.setup({})
-- vim.keymap.set('i', '<CR>', function()
--     if vim.call('zpan#pumselected') == 1 then
--         return vim.call('coc#pum#confirm')
--     else
--         return key_c_g .. 'u' .. ua_core.run(key_cr) .. key_c_r .. '=coc#on_enter()' .. key_cr .. key_c_r .. '=EndwiseDiscretionary()'.. key_cr
--     end
-- end, {expr = true, noremap = true, replace_keycodes = false})

require('ultimate-autopair').setup {
    cr = {
        map = ''
    }
}
