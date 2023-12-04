require('runterm').setup({
  open_in_dir = function()
    return vim.fn.getcwd(-1)
  end,
})

local config = require("user.config")

config.keymaps = config.keymaps or {}
config.keymaps.n = config.keymaps.n or {}

config.keymaps.n['<leader>l'] = {
  label = 'shell',
  cmd = function()
    require('runterm').focus_terminal()
  end,
}

return {}
