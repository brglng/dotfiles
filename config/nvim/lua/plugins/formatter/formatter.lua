return {
    "mhartington/formatter.nvim",
    enabled = false,
    config = function ()
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
    end
}
