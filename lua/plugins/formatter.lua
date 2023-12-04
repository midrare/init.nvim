local config = require("user.config")

config.keymaps = config.keymaps or {}
config.keymaps.n = config.keymaps.n or {}
config.keymaps.x = config.keymaps.x or {}

config.keymaps.n['<leader>ro'] = {
  label = 'reformat',
  cmd = function()
    require("formatter.format")  -- force plugin to lazy load
    vim.cmd('Format') -- or vim.lsp.buf.format,
  end
}

return {
  'mhartington/formatter.nvim',
  lazy = true,
  opts = function(m, opts)
    -- https://github.com/mhartington/formatter.nvim/issues/235
    vim.notify('formatter-nvim monkey-patch applied. (has bug been fixed yet?)')
    local patch_clangformat_bug = function(f)
      local o = f()
      if o.args and type(o.args) == 'table' then
        local new_args = {}
        local skip = false
        for i, v in ipairs(o.args) do
          if skip then
            skip = false
          elseif
            v == '-assume-filename'
            and (o.args[i + 1] == "''" or o.args[i + 1] == '""')
          then
            skip = true
          elseif type(v) ~= 'string' or not v:find('^-style=') then
            table.insert(new_args, v)
          end
        end
        o.args = new_args
      end
      return o
    end

    local for_each = function(f, o)
      for k, v in pairs(o) do
        o[k] = f(v)
      end
    end

    opts = {
      filetype = {
        c = { require('formatter.filetypes.c').clangformat },
        cmake = { require('formatter.filetypes.cmake').cmakeformat },
        cpp = {require('formatter.filetypes.cpp').clangformat, },
        java = {require('formatter.filetypes.java').clangformat, },
        javascript = { require('formatter.filetypes.javascript').prettier },
        json = { require('formatter.filetypes.json').prettier },
        html = { require('formatter.filetypes.html').prettier },
        lua = { require('formatter.filetypes.lua').stylua },
        python = { require('formatter.filetypes.python').black },
        rust = { require('formatter.filetypes.rust').rustfmt },
        sh = { require('formatter.filetypes.sh').shfmt },
        toml = { require('formatter.filetypes.toml').taplo },
        yaml = { require('formatter.filetypes.yaml').pyaml },
        zig = { require('formatter.filetypes.zig').zigfmt },
      },
    }

    opts.filetype.c = for_each(patch_clangformat_bug, opts.filetype.c)
    opts.filetype.cpp = for_each(patch_clangformat_bug, opts.filetype.cpp)
    opts.filetype.java = for_each(patch_clangformat_bug, opts.filetype.java)

    return opts
  end
}
