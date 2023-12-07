return {
  'kazhala/close-buffers.nvim',
  lazy = true,
  cmd = { "BD", "BDelete" },
  init = function(m)
    local config = require("user.config")
    config.keymaps = config.keymaps or {}
    config.keymaps.n = config.keymaps.n or {}
    config.keymaps.x = config.keymaps.x or {}
    config.keymaps.n['<C-w>e'] = {
      label = 'close',
      repeatable = true,
      cmd = function()
        require('close_buffers').delete({ type = 'this' })
      end
    }
    config.keymaps.n['<C-w><C-e>'] = {
      label = 'close',
      repeatable = true,
      hidden = true,
      cmd = function()
        require('close_buffers').delete({ type = 'this' })
      end
    }
    config.keymaps.n['<C-w>E'] = {
      label = 'force close',
      repeatable = true,
      cmd = function()
        require('close_buffers').delete({ type = 'this', force = true })
      end
    }
    config.keymaps.n['<C-w><C-E>'] = {
      label = 'force close',
      repeatable = true,
      hidden = true,
      cmd = function()
        require('close_buffers').delete({ type = 'this', force = true })
      end
    }
  end,
  config = true,
}
