return {
    "luukvbaal/statuscol.nvim",
    config = function ()
        local builtin = require("statuscol.builtin")
        require("statuscol").setup {
            relculright = true,
            bt_ignore = { "nofile", "terminal" },
            segments = {
                {
                    sign = {
                        name = { ".*" },
                        text = { ".*" },
                    },
                    click = "v:lua.ScSa",
                },
                { text = { builtin.lnumfunc }, click = "v:lua.ScLa" },
                { text = { " " } },
                {
                    sign = { namespace = { "gitsigns" }, colwidth = 1, wrap = true },
                    click = "v:lua.ScSa",
                },
                { text = { " " } },
                { text = { builtin.foldfunc },      click = "v:lua.ScFa" },
                { text = { " " } },
            },
        }
    end
}
