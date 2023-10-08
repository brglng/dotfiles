require('lint').linters_by_ft = {
    bash = { " shellcheck" },
    c = { "clangtidy" },
    cmake = { "cmakelint" },
    cpp = { "clangtidy" },
    markdown = { 'vale' },
    shell = { "shellcheck" },
    yaml = { "yamllint" },
    zsh = { "shellcheck" }
}
