return {
  'bennypowers/splitjoin.nvim',
  event = 'VeryLazy',
  keys = {
    {
      'gj',
      function() require'splitjoin'.join() end,
      desc = 'join object',
    },
    {
      'g,',
      function() require'splitjoin'.split() end,
      desc = 'split object',
    },
  },
}
