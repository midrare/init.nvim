local config = require("user.config")

config.keymaps = config.keymaps or {}
config.keymaps.n = config.keymaps.n or {}
config.keymaps.x = config.keymaps.x or {}

config.keymaps.n['g,'] = {
  label = 'split/join object',
  cmd = function()
    require('treesj').toggle()
  end,
}


return {
  'Wansmer/treesj',
  lazy = true,
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  opts = {
    use_default_keymaps = false,
  }
}
