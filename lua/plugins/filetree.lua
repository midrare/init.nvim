vim.g.neo_tree_remove_legacy_commands = 1

local config = require('user.config')

config.keymaps = config.keymaps or {}
config.keymaps.n = config.keymaps.n or {}
config.keymaps.x = config.keymaps.x or {}

config.keymaps.n['<leader>f'] = {
  label = 'file tree',
  cmd = '<cmd>Neotree<cr>',
}

config.filetree = config.filetree or {}
config.filetree.buf_filetype = 'NvimTree'
config.ignored_filetypes = config.ignored_filetypes or {}
table.insert(config.ignored_filetypes, 'neo-tree')
table.insert(config.ignored_filetypes, 'NvimTree')

return {
  {
    'nvim-neo-tree/neo-tree.nvim',
    lazy = true,
    cmd = { 'Neotree' },
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
    },
    opts = function(_, _)
      local ignore = {}
      vim.list_extend(ignore, config.ignored_buftypes)
      vim.list_extend(ignore, config.ignored_filetypes)

      return {
        auto_clean_after_session_restore = true,
        close_if_last_window = true,
        open_files_do_not_replace_types = ignore,
        default_component_configs = {
          modified = {
            symbol = " ",
            highlight = "NeoTreeModified",
          },
          git_status = {
            symbols = {
              added     = "",
              conflict  = "",
              deleted = '',
              ignored = '◌',
              modified  = "",
              renamed   = "󰁕",
              staged = '',
              unmerged = '',
              unstaged = '',
              untracked = '',
            },
          },
        },
        filesystem = {
          filtered_items = { show_hidden_count = false },
          use_libuv_file_watcher = true,
        },
      }
    end,
  }
}
