vim.g.asyncrun_open = 8

local config = require("user.config")
config.telescope = config.telescope or {}
config.telescope.extensions = config.telescope.extensions or {}
table.insert(config.telescope.extensions, 'overseer')

return {
  {
    'stevearc/overseer.nvim',
    lazy = true,
    config = true,
  },
  'sakuemon/telescope-overseer.nvim'
}
