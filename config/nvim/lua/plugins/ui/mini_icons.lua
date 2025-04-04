return {
    "echasnovski/mini.icons",
    version = "*",
    config = function(_, opts)
        require("mini.icons").setup()
        MiniIcons.mock_nvim_web_devicons()
    end
}
