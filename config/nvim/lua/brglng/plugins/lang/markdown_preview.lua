return {
    "iamcco/markdown-preview.nvim",
    ft = { "markdown", "quarto", "rmd", "Avante" },
    build = ":call mkdp#util#install()"
}
