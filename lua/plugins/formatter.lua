local modulename = "formatter.lua"

local config = require("user.config")

config.keymaps = config.keymaps or {}
config.keymaps.n = config.keymaps.n or {}
config.keymaps.x = config.keymaps.x or {}

local format = nil
config.keymaps.n['<leader>ro'] = {
  label = 'reformat',
  cmd = function()
    if format ~= nil then
      format()
    elseif vim.fn.exists(':Format') then
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
  'stevearc/conform.nvim',
  lazy = true,
  cmd = { 'Format' },
  init = function()
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

    format = function(opts)
      opts = opts or {}
      local ft = vim.bo.filetype
      local wants = vim.iter({
        vim.g["formatter_" .. ft] or false,
        config.formatters.filetype[ft] or false,
      }):flatten():filter(function(o) return o and true end):totable()

      local conform = require('conform')
      conform.format(vim.tbl_deep_extend('force', opts, {
        formatters = wants,
      }))
    end

    vim.api.nvim_create_user_command("Format", function(args)
      local range = nil
      if args.count >= 0 then
        local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
        range = {
          start = { args.line1, 0 },
          ["end"] = { args.line2, end_line:len() },
        }
      end

      if format ~= nil then
        format({ range = range })
      end
    end, { range = true })
  end,
  opts = {
    default_format_opts = {
      async = true,
      lsp_format = 'fallback',
      stop_after_first = true,
    },
    notify_no_formatters = false,
  },
}
