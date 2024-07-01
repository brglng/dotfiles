return {
    "luckasRanarison/nvim-devdocs",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
        "nvim-treesitter/nvim-treesitter",
    },
    opts = {
        -- previewer_cmd = "glow",
        -- cmd_args = { "-w", "80" },
        -- picker_cmd = "glow",
        -- picker_cmd_args = { "-w", "80" },
        ensure_installed = {
            "c",
            "cpp",
            "cmake-3.26"
        }
    },
}
