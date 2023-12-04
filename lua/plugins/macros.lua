vim.g.Mac_DefaultRegister = 'q'
vim.g.Mac_SavePersistently = 1

local config = require("user.config")
config.keymaps = config.keymaps or {}
config.keymaps.n = config.keymaps.n or {}
config.keymaps.x = config.keymaps.x or {}
config.keymaps.n['q'] = {
  label = 'playback',
  cmd = '<Plug>(Mac_Play)',
}
config.keymaps.n['<S-q>'] = {
  label = 'record',
  cmd = '<Plug>(Mac_RecordNew)',
}
config.keymaps.n['<M-q>'] = {
  label = 'macros',
  cmd = '<Plug>(Mac_SearchForNamedMacroAndPlay)',
}
config.keymaps.n['[m'] = {
  label = 'prev macro',
  cmd = '<Plug>(Mac_RotateBack)',
}
config.keymaps.n[']m'] = {
  label = 'prev macro',
  cmd = '<Plug>(Mac_RotateForward)',
}

return {
  'svermeulen/vim-macrobatics',
  lazy = true,
  dependencies = 'tpope/vim-repeat',
}
