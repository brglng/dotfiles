return {
    "obsidian-nvim/obsidian.nvim",
    enabled = false,
    version = "*",
    ft = "markdown",

    ---@module 'obsidian'
    ---@type obsidian.config
    opts = {
        workspaces = {
            {
                name = "vault",
                path = "~/github/brglng/vault",
            }
        }
    }
}
