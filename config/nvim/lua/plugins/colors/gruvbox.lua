return {
    {
        "ellisonleao/gruvbox.nvim",
        priority = 1000,
        opts = {
            contrast = "hard",
            -- inverse = false,
            -- invert_signs = false,
            italic = {
                strings = true,
                emphasis = true,
                comments = true,
                operators = false,
                folds = true,
            },
            overrides = {
                GruvboxRedSign = { bg = "NONE" },
                GruvboxGreenSign = { bg = "NONE" },
                GruvboxYellowSign = { bg = "NONE" },
                GruvboxBlueSign = { bg = "NONE" },
                GruvboxPurpleSign = { bg = "NONE" },
                GruvboxAquaSign = { bg = "NONE" },
                GruvboxOrangeSign = { bg = "NONE" },
                WinSeparator = { bg = "NONE" },
                SignColumn = { bg = "NONE" },
                FoldColumn = { bg = "NONE" },
                WinBarNC = { bg = "NONE" },
                IncSearch = {
                    fg = "black",
                    bg = "darkorange",
                    reverse = false
                }
            }
        }
    }
}
