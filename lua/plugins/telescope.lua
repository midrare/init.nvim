local modulename = "telescope.lua"
local config = require("user.config")

config.telescope = config.telescope or {}
config.telescope.extensions = config.telescope.extensions or {}
table.insert(config.telescope.extensions, 'fzf')

-- TODO implement more telescope keybinds
config.keymaps = config.keymaps or {}
config.keymaps.n = config.keymaps.n or {}
config.keymaps.x = config.keymaps.x or {}
config.keymaps.n['<leader>g'] = {
  label = 'files',
  cmd = function()
    require('telescope.builtin').find_files({
      cwd = require('telescope.utils').buffer_dir()
    })
  end
}
config.keymaps.n['<leader>G'] = {
  label = 'project files',
  cmd = function()
    require('telescope.builtin').find_files()
  end
}
config.keymaps.n['<leader>e'] = {
  label = 'grep',
  cmd = function()
    require('telescope.builtin').live_grep({
      cwd = require('telescope.utils').buffer_dir()
    })
  end
}
config.keymaps.n['<leader>E'] = {
  label = 'grep project',
  cmd = function()
    require('telescope.builtin').live_grep()
  end
}
config.keymaps.n['<leader>b'] = {
  label = 'buffers',
  cmd = function()
    require('telescope.builtin').buffers()
  end
}

return {
  'nvim-telescope/telescope.nvim',
  lazy = true,
  cmd = { 'Telescope' },
  dependencies = {
    { 'nvim-lua/plenary.nvim' },
    { 'nvim-telescope/telescope-fzf-native.nvim' },
  },
  config = function(m, opts)
    local telescope = require('telescope')
    telescope.setup(opts)

    vim.cmd([[autocmd User TelescopePreviewerLoaded setlocal wrap]])

    -- if the fzf extension doesn't load, it needs to be compiled
    -- https://github.com/nvim-telescope/telescope-fzf-native.nvim/issues/43

    if config.telescope and config.telescope.extensions then
      for _, extension in pairs(config.telescope.extensions) do
        local status_ok, errmsg = pcall(telescope.load_extension, extension)
        if not status_ok then
          local msg = 'Failed to load telescope extension "'
          .. tostring(extension)
          .. '"'
          vim.notify(msg, vim.log.levels.ERROR, { title = modulename })
          if errmsg and #errmsg > 0 then
            vim.notify(errmsg, vim.log.levels.TRACE, { title = modulename })
          end
        end
      end
    end
  end,
  opts = function()
    local tsactions = require('telescope.actions')
    return {
      defaults = {
        wrap_results = true,
        mappings = {
          i = {
            ['<C-u>'] = tsactions.results_scrolling_up,
            ['<C-d>'] = tsactions.results_scrolling_down,
            ['<A-u>'] = tsactions.preview_scrolling_up,
            ['<A-d>'] = tsactions.preview_scrolling_down,
            ['<esc>'] = tsactions.close,
          },
          n = {
            ['<C-u>'] = tsactions.results_scrolling_up,
            ['<C-d>'] = tsactions.results_scrolling_down,
            ['<A-u>'] = tsactions.preview_scrolling_up,
            ['<A-d>'] = tsactions.preview_scrolling_down,
            ['<esc>'] = tsactions.close,
          },
        },
      },
    }
  end
}
