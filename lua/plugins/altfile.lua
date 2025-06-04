local modulename = "altfile.lua"
local config = require("user.config")

config.keymaps = config.keymaps or {}
config.keymaps.n = config.keymaps.n or {}
config.keymaps.x = config.keymaps.x or {}

config.keymaps.n['<tab>'] = {
  label = 'file jump',
  cmd = function()
    require('altarfile').open()
  end,
}

return {
  'midrare/altarfile.nvim',
  lazy = true,
  opts = {
    mappings = {
      {
        pattern = "(.*)%.([ch])(pp)?$",
        target = "/tests/%1_test.c%3",
        context = "test",
      }
    },
  },
}
