local config = require("user.config")
config.telescope = config.telescope or {}
config.telescope.extensions = config.telescope.extensions or {}
table.insert(config.telescope.extensions, 'notify')

return {
  {
    'stevearc/dressing.nvim',
    event = 'VeryLazy',
    config = true,
  },
  {
    'rcarriga/nvim-notify',
    event = "VimEnter",
    init = function()
      vim.notify = require("notify")
    end,
    opts = {
      render = "wrapped-compact",
      stages = "static",
    },
  },
}
