local modulename = "altfile.lua"
local config = require("user.config")

config.keymaps = config.keymaps or {}
config.keymaps.n = config.keymaps.n or {}
config.keymaps.x = config.keymaps.x or {}

config.keymaps.n['<tab>'] = {
  label = 'file jump',
  cmd = function()
    require("ouroboros").switch()
  end,
}

return {
  'jakemason/ouroboros',
  dependencies = 'nvim-lua/plenary.nvim',
  event = 'VeryLazy',
  opts = {
    extension_preferences_table = {
      c = {h = 3, hpp = 2, hxx = 1},
      h = {c = 3, cpp = 2, cxx = 1},
      cpp = {hpp = 3, hxx = 2, h = 1},
      cxx = {hpp = 3, hxx = 2, h = 1},
      hpp = {cpp = 3, cxx = 2, c = 1},
      hxx = {cpp = 3, cxx = 2, c = 1},
      inl = {cpp = 3, hpp = 2, h = 1},
    },
    switch_to_open_pane_if_possible = true,
  }
}
