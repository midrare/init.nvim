local config = require('user.config')

config.keymaps = config.keymaps or {}
config.keymaps.n = config.keymaps.n or {}
config.keymaps.x = config.keymaps.x or {}

config.keymaps.n['<leader>ru'] = {
  label = 'lorem',
  cmd = function()
    -- HACK lorem.nvim does not work with count less than three
    local cnt = vim.v.count
    local s = require('lorem').gen_words(math.max(3, cnt))

    if cnt < 3 then
      local s2 = ""
      local i = 0
      for m in s:gmatch("([^%s]+)") do
        if #s2 > 0 then
          s2 = s2 .. " "
        end
        s2 = s2 .. m
        i = i + 1
        if i >= cnt then
          break
        end
      end
      s = s2
    end

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
