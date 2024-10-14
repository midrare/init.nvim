local config = require('user.config')

config.keymaps = config.keymaps or {}
config.keymaps.n = config.keymaps.n or {}
config.keymaps.x = config.keymaps.x or {}

config.keymaps.n['<leader>ru'] = {
  label = 'lorem',
  cmd = function()
    local s = require('lorem').words(math.max(1, vim.v.count))

    -- HACK remove period appended by lorem.nvim
    if s:sub(#s, #s) == "." then
      s = s:sub(1, #s - 1)
    end

    vim.api.nvim_paste(s, true, -1)
  end,
}

return {
  'derektata/lorem.nvim',
  lazy = true,
  opts = {
    sentenceLength = {
      words_per_sentence = 99999,
      sentences_per_paragraph = 99999,
    },
    comma_chance = 0,
    max_commas_per_sentence = 0,
  },
}
