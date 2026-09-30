return {
  "zgs225/pi2.nvim",
  dependencies = {
    "MeanderingProgrammer/render-markdown.nvim",
    "HakonHarnes/img-clip.nvim",
  },
  opts = {
  },
  config = function(_, opts)
    require("pi").setup(opts)
    vim.api.nvim_create_autocmd({ "BufEnter", "InsertEnter" }, {
      callback = function(ev)
        local bo = vim.bo[ev.buf]
        if bo.filetype == "pi-chat-prompt" and bo.completefunc ~= "" then
          bo.omnifunc = bo.completefunc
        end
      end
    })
  end,
}
