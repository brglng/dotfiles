return {
    "rachartier/tiny-inline-diagnostic.nvim",
    cond = false,
    event = "LspAttach",
    opts = {
        preset = "simple",
        hi = {
            background = "None"
        },
        options = {
            show_source = {
                enabled = true,
                if_many = false,
            },
            use_icons_from_diagnostic = true,
            -- set_arrow_to_diag_color = true,
            multilines = {
                enabled = true,
                always_show = true,
            },
            show_all_diags_on_cursorline = true,
            enable_on_insert = true,
            enable_on_select = true,
        }
    }
}
