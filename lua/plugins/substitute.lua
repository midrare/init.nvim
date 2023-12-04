local config = require("user.config")
config.keymaps = config.keymaps or {}
config.keymaps.n = config.keymaps.n or {}
config.keymaps.x = config.keymaps.x or {}
config.keymaps.n['gd'] = {
  label = 'replace',
  cmd = function()
    require('substitute').operator()
  end,
}
config.keymaps.n['gdd'] = {
  label = 'replace',
  cmd = function()
    require('substitute').line()
  end,
}
config.keymaps.x['gd'] = {
  label = 'replace',
  cmd = function()
    require('substitute').visual()
  end,
}


return {
  'gbprod/substitute.nvim',
  lazy = true,
  config = true,
}
