return {
    "L3MON4D3/LuaSnip",
    dependencies = {
        "rafamadriz/friendly-snippets",
    },
    config = function ()
        require("luasnip.loaders.from_vscode").lazy_load {
            default_priority = 500,
            override_priority = 500,
        }

        local ls = require("luasnip")
        local s = ls.snippet
        local sn = ls.snippet_node
        local isn = ls.indent_snippet_node
        local t = ls.text_node
        local i = ls.insert_node
        local f = ls.function_node
        local c = ls.choice_node
        local d = ls.dynamic_node
        local r = ls.restore_node
        local events = require("luasnip.util.events")
        local ai = require("luasnip.nodes.absolute_indexer")
        local extras = require("luasnip.extras")
        local l = extras.lambda
        local rep = extras.rep
        local p = extras.partial
        local m = extras.match
        local n = extras.nonempty
        local dl = extras.dynamic_lambda
        local fmt = require("luasnip.extras.fmt").fmt
        local fmta = require("luasnip.extras.fmt").fmta
        local conds = require("luasnip.extras.expand_conditions")
        local postfix = require("luasnip.extras.postfix").postfix
        local types = require("luasnip.util.types")
        local parse = require("luasnip.util.parser").parse_snippet
        local ms = ls.multi_snippet
        local k = require("luasnip.nodes.key_indexer").new_key

        ls.add_snippets("c", {
            s("once", {
                t{"#ifndef "}, i(1),
                f(function()
                    return vim.fn.substitute(vim.fn.toupper(vim.fn.expand("%:t:r")), "\\.", "_", "g") .. "_" .. vim.fn.toupper(vim.fn.expand("%:e"))
                end),
                t{"", "#define "}, rep(1),
                f(function()
                    return vim.fn.substitute(vim.fn.toupper(vim.fn.expand("%:t:r")), "\\.", "_", "g") .. "_" .. vim.fn.toupper(vim.fn.expand("%:e"))
                end),
                t{"", "", ""},
                i(0),
                t{"", "", "#endif /* "}, rep(1),
                f(function()
                    return vim.fn.substitute(vim.fn.toupper(vim.fn.expand("%:t:r")), "\\.", "_", "g") .. "_" .. vim.fn.toupper(vim.fn.expand("%:e")) .. " */"
                end),
            }),
            s("extc", {
                t{"#ifdef __cplusplus", ""},
                t{"extern \"C\" {", ""},
                t{"#endif", ""},
                t{"", ""},
                i(0),
                t{"", "", ""},
                t{"#ifdef __cplusplus", ""},
                t{"}", ""},
                t{"#endif"},
            })
        }, {
            default_priority = 2000,
            override_priority = 2000,
        })

        ls.filetype_extend("cpp", {"c"})

        ls.add_snippets("cpp", {
            s("ns", {
                t{"namespace "}, i(1), t{" {", "", ""},
                i(0),
                t{"", "", "} // namespace "}, rep(1)
            })
        }, {
            default_priority = 2000,
            override_priority = 2000,
        })
    end
}
