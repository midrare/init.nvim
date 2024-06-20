local config = require("user.config")

config.keymaps = config.keymaps or {}
config.keymaps.n = config.keymaps.n or {}
config.keymaps.x = config.keymaps.x or {}

return {
  {
    'lewis6991/gitsigns.nvim',
    event = "VeryLazy",
    opts = {
      signs = {
        add = { text = '▎' },
        change = { text = '▎' },
        delete = { text = '⭸' },
        topdelete = { text = '⭷' },
        changedelete = { text = '▎' },
        untracked = { text = '▎' },
      },
    },
  },
}
