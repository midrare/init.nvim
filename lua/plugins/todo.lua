local config = require("user.config")

config.keymaps = config.keymaps or {}
config.keymaps.n = config.keymaps.n or {}
config.keymaps.x = config.keymaps.x or {}

config.keymaps.n['<leader>i'] = {
  label = 'todo',
  cmd = function()
    require("todo-comments")
    vim.cmd('<cmd>TodoLocList<cr>')
  end
}


return {
  {
    'folke/todo-comments.nvim',
    event = "VeryLazy",
    dependencies = { 'nvim-lua/plenary.nvim', lazy = true },
    opts = {
      highlight = { pattern = [[.*<(KEYWORDS)>]] },
      search = { pattern = [[\b(KEYWORDS)\b]] },
      keywords = {
        -- split strings to prevent false positive when this file is scanned
        ['W' .. 'I' .. 'P'] = {
          icon = '󰥯',
          color = '#ff00ff',
          alt = { 'DEB' .. 'UG', 'UNFIN' .. 'ISHED' },
        },
      },
    }
  }
}
