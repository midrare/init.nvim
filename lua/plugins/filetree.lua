vim.g.neo_tree_remove_legacy_commands = 1

local config = require('user.config')

config.keymaps = config.keymaps or {}
config.keymaps.n = config.keymaps.n or {}
config.keymaps.x = config.keymaps.x or {}

config.keymaps.n['<leader>f'] = {
  label = 'file tree',
  cmd = function()
    require('nvim-tree.api').tree.focus()
  end,
}

config.filetree = config.filetree or {}
config.filetree.buf_filetype = 'NvimTree'
config.ignored_filetypes = config.ignored_filetypes or {}
table.insert(config.ignored_filetypes, 'neo-tree')
table.insert(config.ignored_filetypes, 'NvimTree')

return {
  {
    'nvim-tree/nvim-tree.lua',
    lazy = true,
    dependencies = 'nvim-tree/nvim-web-devicons',
    opts = {
      sync_root_with_cwd = true,
      respect_buf_cwd = true,
      diagnostics = {
        enable = true,
        show_on_dirs = true,
      },
      renderer = {
        icons = {
          glyphs = {
            git = {
              unstaged = '', -- 
              staged = '', -- 
              unmerged = '',
              renamed = '➜',
              untracked = '',
              deleted = '',
              ignored = '◌', -- ◌ ﯏ ﯏
            },
          },
        },
      },
      filters = { dotfiles = true, custom = { '__pycache__' } },
      on_attach = function(bufnr)
        require('nvim-tree.api').config.mappings.default_on_attach(bufnr)

        -- disable open in-place (take over filetree window)
        vim.keymap.del('n', '<C-e>', { buffer = bufnr })
        vim.keymap.set('n', '<C-e>', '<Nop>', { buffer = bufnr, desc = 'NOP' })
      end,
    },
  },
}
