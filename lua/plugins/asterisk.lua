local config = require("user.config")

config.keymaps = config.keymaps or {}
config.keymaps.n = config.keymaps.n or {}
config.keymaps.x = config.keymaps.x or {}

config.keymaps.n['*'] = {
  cmd = function()
    require('lasterisk').search()
  end,
  label = 'word',
}
config.keymaps.n['g*'] = {
  cmd = function()
    require('lasterisk').search({ is_whole = false })
  end,
  label = 'partial word',
}
config.keymaps.x['g*'] = {
  cmd = function()
    require('lasterisk').search()
  end,
  label = 'word',
}

return {
  'rapan931/lasterisk.nvim',
  lazy = true,
}
