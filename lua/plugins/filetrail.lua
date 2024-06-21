local config = require("user.config")

config.keymaps = config.keymaps or {}
config.keymaps.n = config.keymaps.n or {}
config.keymaps.x = config.keymaps.x or {}


config.keymaps.n['<alt>e'] = {
  label = 'pop trail',
  cmd = function()
    require("trailblazer").track_back()
  end,
}

config.keymaps.n['<alt>E'] = {
  label = 'append trail',
  cmd = function()
    require("trailblazer").new_trail_mark()
  end
}

config.keymaps.n['z'] = {
  repeatable = true,
  label = 'file trail',
}

config.keymaps.n['z<c-n>'] = {
  repeatable = true,
  cmd = function()
    require('trailblazer').peek_move_next_down()
  end,
  label = 'trail next',
}

config.keymaps.n['z<c-p>'] = {
  repeatable = true,
  cmd = function()
    require('trailblazer').peek_move_previous_up()
  end,
  label = 'trail prev',
}


return {
  'LeonHeidelbach/trailblazer.nvim',
  lazy = true,
  config = true,
}
