local builtin = require("statuscol.builtin")
require("statuscol").setup({
    relculright = true,
    segments = {
        { text = { "%s" },              click = "v:lua.ScSa" },
        { text = { builtin.lnumfunc },  click = "v:lua.ScLa" },
        { text = { builtin.foldfunc },  click = "v:lua.ScFa" },
        { text = { " " } },
    },
})
