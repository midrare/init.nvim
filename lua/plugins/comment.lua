local config = require("user.config")

config.keymaps = config.keymaps or {}
config.keymaps.n = config.keymaps.n or {}
config.keymaps.x = config.keymaps.x or {}

config.keymaps.n['gcb'] = {
  label = 'line',
  cmd = function()
    require('comment-box').llline()
  end,
}
config.keymaps.n['gcB'] = {
  label = 'box',
  cmd = function()
    require('comment-box').llbox()
  end,
}
config.keymaps.n['gcn'] = {
  label = 'annotations',
  cmd = function()
    require('neogen').generate()
  end,
}
config.keymaps.n['gcc'] = {
  label = 'comment',
  cmd = function()
    require('Comment.api').toggle.linewise.current()
  end,
}
config.keymaps.x['gcc'] = {
  label = 'comment',
  cmd = function()
    local esc = vim.api.nvim_replace_termcodes('<ESC>', true, false, true)
    vim.api.nvim_feedkeys(esc, 'nx', false)
    require('Comment.api').toggle.linewise(vim.fn.visualmode())
  end
}


return {
  {
    'numToStr/Comment.nvim',
    opts = { mappings = false },
    lazy = true,
  },
  {
    'LudoPinelli/comment-box.nvim',
    lazy = true,
  },
  {
    'danymat/neogen',
    lazy = true,
    dependencies = 'nvim-treesitter/nvim-treesitter',
    config = true,
  }
}
