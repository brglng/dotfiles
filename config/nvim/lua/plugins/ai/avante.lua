return {
    "yetone/avante.nvim",
    enabled = false,
    event = "VeryLazy",
    version = false,
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "stevearc/dressing.nvim",
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        --- The below dependencies are optional,
        "echasnovski/mini.icons",
        {
            -- support for image pasting
            "HakonHarnes/img-clip.nvim",
            event = "VeryLazy",
            opts = {
                -- recommended settings
                default = {
                embed_image_as_base64 = false,
                prompt_for_file_name = false,
                drag_and_drop = {
                    insert_mode = true,
                },
                -- required for Windows users
                use_absolute_path = true,
                },
            },
        },
        { "MeanderingProgrammer/render-markdown.nvim" }
    },
    build = (function()
        if vim.uv.os_uname().sysname == 'Windows_NT' then
            return "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
        else
            return "make"
        end
    end)(),
    opts = {
        -- provider = "claude",
        -- auto_suggestions_provider = "copilot"
    },
}
