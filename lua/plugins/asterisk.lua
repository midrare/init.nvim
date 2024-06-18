local config = require("user.config")

config.keymaps = config.keymaps or {}
config.keymaps.n = config.keymaps.n or {}
config.keymaps.x = config.keymaps.x or {}

config.keymaps.n['*'] = {
  cmd = '<Plug>(asterisk-z*)',
  label = 'word',
}
config.keymaps.n['#'] = {
  cmd = '<Plug>(asterisk-z#)',
  label = 'partial word',
}
config.keymaps.x['g*'] = {
  cmd = '<Plug>(asterisk-gz*)',
  label = 'word (backwards)',
}

config.keymaps.x['g#'] = {
  cmd = 'map g# <Plug>(asterisk-gz#)',
  label = 'partial word (backwards)',
}

return {
  'haya14busa/vim-asterisk',
  event = "VeryLazy",
}
