local actions = require("telescope.actions")
require("telescope").setup {
    defaults = {
        sorting_strategy = "ascending",
        layout_config = {
            prompt_position = "top",
            height = 0.62,
        },
        mappings = {
            i = {
                ["<Esc>"] = actions.close,
                ["<TAB>"] = { "<Esc>", type = "command" },
            },
            n = {
                ["<Space>"] = actions.toggle_selection
            }
        }
    },
}
