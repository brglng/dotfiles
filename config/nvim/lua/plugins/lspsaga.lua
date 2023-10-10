require('lspsaga').setup {
    code_action = {
        extend_gitsigns = true,
        show_server_name = true
    },
    diagnostic = {
        diagnostic_only_current = true
    },
    lightbulb = {
        sign = false
    },
    outline = {
        close_after_jump = true,
        layout = 'float'
    }
}
