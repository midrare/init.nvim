local modulename = "formatter.lua"

local config = require("user.config")

config.keymaps = config.keymaps or {}
config.keymaps.n = config.keymaps.n or {}
config.keymaps.x = config.keymaps.x or {}

config.keymaps.n['<leader>ro'] = {
  label = 'reformat',
  cmd = function()
    if vim.fn.exists(':Format') then
      vim.cmd('Format')
    else
      vim.lsp.buf.format()
    end
  end
}

config.formatters = config.formatters or {}
config.formatters.filetype = config.formatters.filetype or {}
config.formatters.filetype['c'] = 'clangformat'
config.formatters.filetype['cmake'] = 'cmakeformat'
config.formatters.filetype['cpp'] = 'clangformat'
config.formatters.filetype['java'] = 'clangformat'
config.formatters.filetype['javascript'] = 'prettier'
config.formatters.filetype['json'] = 'prettier'
config.formatters.filetype['kotlin'] = 'ktlint'
config.formatters.filetype['html'] = 'prettier'
config.formatters.filetype['lua'] = 'stylua'
config.formatters.filetype['python'] = 'yapf'
config.formatters.filetype['rust'] = 'rustfmt'
config.formatters.filetype['sh'] = 'shfmt'
config.formatters.filetype['toml'] = 'taplo'
config.formatters.filetype['yaml'] = 'pyaml'
config.formatters.filetype['zig'] = 'zigfmt'

return {
  'mhartington/formatter.nvim',
  lazy = true,
  cmd = { 'Format' },
  opts = {
    filetype = {
      ["*"] = {
        function()
          local ft = vim.bo.filetype
          local wants = {
            vim.g["formatter_" .. ft] or false,
            config.formatters.filetype[ft] or false,
          }

          local _, available = pcall(require, "formatter.filetypes." .. ft)
          available = available or {}

          for _, want in ipairs(wants) do
            if want and available[want] then
              return available[want]()
            end
          end

          vim.lsp.buf.format()
          return nil
        end
      }
    },
  },
}
