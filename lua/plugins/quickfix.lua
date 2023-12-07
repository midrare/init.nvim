return {
  {
    "kevinhwang91/nvim-bqf",
    event = "VeryLazy",
    init = function(m)
      local config = require("user.config")

      config.keymaps = config.keymaps or {}
      config.keymaps.n = config.keymaps.n or {}

      config.keymaps.n['<leader>x'] = {
        label = 'quickfix',
        cmd = '<cmd>copen<cr>',
      }
      config.keymaps.n['<leader>z'] = {
        label = 'loclist',
        cmd = '<cmd>lopen<cr>',
      }
      config.keymaps.n['<leader>c'] = {
        label = 'diagnostics',
        cmd = function()
          require("diaglist").open_all_diagnostics()
        end,
      }
      config.keymaps.n['<leader>v'] = {
        label = 'references',
        cmd = function()
          vim.lsp.buf.references(nil, { on_list = function(opts)
            vim.fn.setloclist(0, {}, ' ', opts)
            vim.api.nvim_command('lopen')
          end})
        end,
      }

      config.ignored_filetypes = config.ignored_filetypes or {}
      config.ignored_buftypes = config.ignored_buftypes or {}
      table.insert(config.ignored_filetypes, 'qf')
      table.insert(config.ignored_buftypes, 'quickfix')
    end,
    config = true,
  },
  {
    "onsails/diaglist.nvim",
    lazy = true,
    config = function(m, opts)
      require("diaglist").init(opts)
    end,
    opts = { debounce_ms = 500 }
  }
}
