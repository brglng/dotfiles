require("formatter").setup {
    filetype = {
        c = {
            require("formatter.filetypes.c").clangformat
        },
        cpp = {
            require("formatter.filetypes.cpp").clangformat
        },
    }
}
