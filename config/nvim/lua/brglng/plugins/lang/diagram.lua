local current_dir = vim.fs.normalize(vim.fs.dirname(debug.getinfo(1, "S").source:sub(2)))

return {
  "3rd/diagram.nvim",
  -- dir = vim.fs.normalize("~/github/brglng/diagram.nvim"),
  dependencies = {
    "3rd/image.nvim"
  },
  opts = {
    renderer_options = {
      mermaid = {
        cli_args = { "-p", current_dir .. "/puppeteer-config.json" },
        background = "transparent",
        scale = 2,
      },
    }
  },
  config = function(_, opts)
    require("diagram").setup(vim.tbl_deep_extend("force", opts, {
      integrations = {
        require("diagram.integrations.markdown"),
        require("diagram.integrations.neorg"),
      },
    }))
  end
}
