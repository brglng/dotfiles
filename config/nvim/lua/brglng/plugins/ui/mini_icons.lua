return {
    "echasnovski/mini.icons",
    version = "*",
    enabled = true,
    opts = {},
    config = function(_, opts)
        require("mini.icons").setup(opts)
        MiniIcons.mock_nvim_web_devicons()
    end
}
