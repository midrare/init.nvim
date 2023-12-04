local config = require("user.config")

config.keymaps = config.keymaps or {}
config.keymaps.n = config.keymaps.n or {}
config.keymaps.x = config.keymaps.x or {}

config.keymaps.n['<leader>t'] = {
  label = 'outline',
  cmd = function()
    require('symbols-outline').open_outline()
  end,
}

config.ignored_buftypes = config.ignored_buftypes or {}
table.insert(config.ignored_buftypes, 'Outline')

config.fileoverview = config.fileoverview or {}
config.fileoverview.buf_filetype = 'Outline'

return {
  {
    'simrat39/symbols-outline.nvim',
    lazy = true,
    config = true,
  }
}
