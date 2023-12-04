local config = require("user.config")
config.ignored_filetypes = config.ignored_filetypes or {}
config.telescope = config.telescope or {}
config.telescope.extensions = config.telescope.extensions or {}
table.insert(config.telescope.extensions, 'scope')


config.keymaps = config.keymaps or {}
config.keymaps.n = config.keymaps.n or {}

config.keymaps.n['[b'] = {
  cmd = function()
    require("bufferline").cycle(-1)
  end,
  label = 'previous buffer',
}

config.keymaps.n[']b'] = {
  cmd = function()
    require("bufferline").cycle(1)
  end,
  label = 'next buffer',
}

config.keymaps.n['[B'] = {
  cmd = function()
    require("bufferline").go_to(1)
  end,
  label = 'first buffer',
}

config.keymaps.n[']B'] = {
  cmd = function()
    require("bufferline").go_to(-1)
  end,
  label = 'last buffer',
}


return {
  {
    'akinsho/bufferline.nvim',
    event = 'VimEnter',
    dependencies = 'kyazdani42/nvim-web-devicons',
    opts = {
      options = {
        custom_filter = function(bufnr, bufnrs)
          local buf = vim.bo[bufnr]
          if
            not buf
            or vim.tbl_contains(config.ignored_filetypes, buf.filetype)
          then
            return false
          end
          return true
        end,
      },
    }
  },
  {
    'tiagovla/scope.nvim',
    priority = 100,
    opts = { restore_state = true }
  }
}
