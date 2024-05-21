local config = require('user.config')

config.keymaps = config.keymaps or {}
config.keymaps.n = config.keymaps.n or {}
config.keymaps.x = config.keymaps.x or {}

config.keymaps.n['<leader>ru'] = {
  label = 'lorem',
  cmd = function()
    local s = require('lorem').gen_words(math.max(1, vim.v.count))
    vim.api.nvim_paste(s, true, -1)
  end,
}

return {
  'derektata/lorem.nvim',
  lazy = true,
  opts = {
    sentenceLength = 'mixedShort',
    comma = 0,
  },
}
