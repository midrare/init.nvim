local config = require("user.config")

config.keymaps = config.keymaps or {}
config.keymaps.n = config.keymaps.n or {}
config.keymaps.x = config.keymaps.x or {}

config.keymaps.n['<leader>q'] = {
  label = 'vcs',
}
config.keymaps.n['<leader>qs'] = {
  label = 'stage',
  cmd = function()
    require('vgit').buffer_hunk_stage()
  end,
}
config.keymaps.n['<leader>qS'] = {
  label = 'stage buffer',
  cmd = function()
    require('vgit').buffer_stage()
  end,
}
config.keymaps.n['<leader>qU'] = {
  label = 'unstage buffer',
  cmd = function()
    require('vgit').buffer_unstage()
  end,
}

return {
  {
    'lewis6991/gitsigns.nvim',
    event = "VeryLazy",
    opts = {
      signs = {
        add = {
          hl = 'GitSignsAdd',
          text = '▎',
          numhl = 'GitSignsAddNr',
          linehl = 'GitSignsAddLn',
        },
        change = {
          hl = 'GitSignsChange',
          text = '▎',
          numhl = 'GitSignsChangeNr',
          linehl = 'GitSignsChangeLn',
        },
        delete = {
          hl = 'GitSignsDelete',
          text = '⭸',
          numhl = 'GitSignsDeleteNr',
          linehl = 'GitSignsDeleteLn',
        },
        topdelete = {
          hl = 'GitSignsDelete',
          text = '⭷',
          numhl = 'GitSignsDeleteNr',
          linehl = 'GitSignsDeleteLn',
        },
        changedelete = {
          hl = 'GitSignsChange',
          text = '▎',
          numhl = 'GitSignsChangeNr',
          linehl = 'GitSignsChangeLn',
        },
        untracked = {
          hl = 'GitSignsAdd',
          text = '▎',
          numhl = 'GitSignsAddNr',
          linehl = 'GitSignsAddLn',
        },
      },
    },
  },
  {
    'tanvirtin/vgit.nvim',
    lazy = true,
    dependencies = 'nvim-lua/plenary.nvim',
    -- disable vgit.nvim gutter in favor of gitsigns.nvim
    opts = { live_gutter = { enabled = false } }
  }
}
