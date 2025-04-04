return {
    "jbyuki/nabla.nvim",
    enabled = false,
    keys = {
        {
            "<Leader>p",
            mode = { "n" },
            function()
                require("nabla").toggle_virt {
                    autogen = true,
                    silent = true,
                    align_center = true
                }
            end,
            desc = "Toggle LaTeX Preview"
        }
    }
}
