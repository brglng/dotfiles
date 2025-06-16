return {
    "luukvbaal/statuscol.nvim",
    enabled = true,
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    config = function ()
        local builtin = require("statuscol.builtin")
        require("statuscol").setup {
            relculright = true,
            ft_ignore = { "neo-tree", "neotree" },
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
                -- { text = { " " } },
                {
                    sign = { namespace = { "gitsigns" }, colwidth = 1, wrap = true },
                    click = "v:lua.ScSa",
                },
                -- { text = { " " } },
                { text = { builtin.foldfunc },      click = "v:lua.ScFa" },
                { text = { " " } },
            },
        }
    end
}
