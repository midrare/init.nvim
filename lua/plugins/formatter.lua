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
        python = { require('formatter.filetypes.python').yapf },
        rust = { require('formatter.filetypes.rust').rustfmt },
        sh = { require('formatter.filetypes.sh').shfmt },
        toml = { require('formatter.filetypes.toml').taplo },
        yaml = { require('formatter.filetypes.yaml').pyaml },
        zig = { require('formatter.filetypes.zig').zigfmt },
      },
    }

    return opts
  end
}
