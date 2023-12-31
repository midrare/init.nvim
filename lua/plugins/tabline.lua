return {
  {
    "willothy/nvim-cokeline",
    event = 'VimEnter',
    dependencies = {
      "nvim-lua/plenary.nvim",
      "kyazdani42/nvim-web-devicons",
      "stevearc/resession.nvim",
    },
    init = function(m)
      local config = require("user.config")
      config.ignored_filetypes = config.ignored_filetypes or {}

      config.keymaps = config.keymaps or {}
      config.keymaps.n = config.keymaps.n or {}

      config.keymaps.n['[b'] = {
        cmd = function()
          require("cokeline.mappings").by_step("focus", -1)
        end,
        label = 'previous buffer',
        repeatable = true,
      }

      config.keymaps.n[']b'] = {
        cmd = function()
          require("cokeline.mappings").by_step("focus", 1)
        end,
        label = 'next buffer',
        repeatable = true,
      }

      config.keymaps.n['[B'] = {
        cmd = function()
          require("cokeline.mappings").by_step("switch", -1)
        end,
        label = 'prev buffer pos',
        repeatable = true,
      }

      config.keymaps.n[']B'] = {
        cmd = function()
          require("cokeline.mappings").by_step("switch", 1)
        end,
        label = 'next buffer pos',
        repeatable = true,
      }

      config.keymaps.n['<C-w>e'] = {
        label = 'close buffer',
        repeatable = true,
        cmd = function()
          require("cokeline.mappings").by_step("close", 0)
        end
      }
      config.keymaps.n['<C-w><C-e>'] = {
        label = 'close buffer',
        repeatable = true,
        hidden = true,
        cmd = function()
          require("cokeline.mappings").by_step("close", 0)
        end
      }
    end,
    opts = {
      buffers = {
        filter_valid = function(buf)
          local config = require("user.config")
          for _, ft in ipairs(config.ignored_filetypes or {}) do
            if ft == buf.filetype then
              return false
            end
          end
          for _, bt in ipairs(config.ignored_buftypes or {}) do
            if bt == buf.type then
              return false
            end
          end
          return true
        end,
      }
    }
  },
  {
    "tiagovla/scope.nvim",
    init = function(m)
      local config = require("user.config")
      config.telescope = config.telescope or {}
      config.telescope.extensions = config.telescope.extensions or {}
      table.insert(config.telescope.extensions, 'scope')
    end,
    config = true,
  }
}
