local config = require('user.config')
config.telescope = config.telescope or {}
config.telescope.extensions = config.telescope.extensions or {}
table.insert(config.telescope.extensions, 'microkasten')

return {
  {
    's1n7ax/nvim-window-picker',
    lazy = true,
    opts = function(m, opts)
      return {
        filter_rules = { bo = { filetype = config.ignored_filetypes } },
      }
    end,
  },
  {
    'midrare/microkasten.nvim',
    branch = 'dev',
    event = "VeryLazy",
    opts = function(m, opts)
      return {
        default_ext = '.norg',
        on_attach = function()
          local function create_mappings(microkasten)
            return {
              {
                name = 'create',
                mode = 'n',
                key = '<leader>rn',
                f = microkasten.create,
              },
              {
                name = 'rename',
                mode = 'n',
                key = '<leader>rr',
                f = microkasten.rename,
              },
              {
                name = 'open link',
                mode = 'n',
                key = 'gf',
                f = function()
                  microkasten.open_link_at(nil, false)
                end,
              },
              {
                name = 'open link in window',
                mode = 'n',
                key = 'gF',
                f = function()
                  microkasten.open_link_at(nil, true)
                end,
              },
              {
                name = 'filenames',
                mode = 'n',
                key = '<leader>g',
                f = microkasten.filename_picker,
              },
              {
                name = 'grep',
                mode = 'n',
                key = '<leader>G',
                f = microkasten.grep_picker,
              },
              {
                name = 'tags',
                mode = 'n',
                key = '<leader>j',
                f = microkasten.tag_picker,
              },
              {
                name = 'backlinks',
                mode = 'n',
                key = '<leader>v',
                f = microkasten.backlink_picker,
              },
              {
                name = 'yank uid',
                mode = 'n',
                key = '<leader>yu',
                f = function()
                  local reg = vim.api.nvim_get_vvar('register')
                  local uid = microkasten.get_current_uid()
                  vim.fn.setreg(reg, uid)
                end,
              },
            }
          end

          local function register_keymap(keymap, whichkey)
            assert(
              keymap.f,
              'Expected non-nil func for keymap "' .. tostring(keymap.key) .. '"'
            )
            assert(keymap.key, 'Expected non-nil key for keymap')

            if whichkey then
              whichkey.register({
                [keymap.key] = { keymap.f, keymap.name },
              }, {
                mode = keymap.mode or 'n',
                silent = true,
                buffer = 0,
              })
            end
            vim.keymap.set(keymap.mode or 'n', keymap.key, keymap.f, { buffer = 0 })
          end

          local _, whichkey = pcall(require, 'which-key')
          local mappings = create_mappings(require("microkasten"))
          for _, keymap in ipairs(mappings) do
            register_keymap(keymap, whichkey)
          end
        end,
      }
    end
  }
}
