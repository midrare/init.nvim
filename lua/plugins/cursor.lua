return {
  'folke/flash.nvim',
  event = 'VeryLazy',
  opts = {},
  keys = {
    {
      's',
      mode = { 'n', 'x', 'o' },
      function()
        require('flash').jump({
          forward = true,
          wrap = false,
          multi_window = false,
        })
      end,
      desc = 'jump',
    },
    {
      'S',
      mode = { 'n', 'x', 'o' },
      function()
        require('flash').jump({
          forward = false,
          wrap = false,
          multi_window = false,
        })
      end,
      desc = 'jump backward',
    },
  },
}
