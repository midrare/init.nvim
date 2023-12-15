return {
  {
    'stevearc/aerial.nvim',
    lazy = true,
    init = function(m)
      local config = require("user.config")

      config.keymaps = config.keymaps or {}
      config.keymaps.n = config.keymaps.n or {}
      config.keymaps.x = config.keymaps.x or {}

      config.keymaps.n['<leader>t'] = {
        label = 'outline',
        cmd = function()
          require('aerial').open({focus = true})
        end,
      }
    end,
    opts = function(m, opts)
      local config = require("user.config")
      return {
        layout = {
          placement = "edge",
          resize_to_content = false,
          min_width = 25,
        },
        attach_mode = "global",
        ignore = {
          filetypes = config.ignored_filetypes,
          buftypes = config.ignored_buftypes,
        }
      }
    end,
  }
}
