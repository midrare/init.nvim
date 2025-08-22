return {
  {
    'wellle/targets.vim',
    event = 'VeryLazy',
  },
  {
    'kana/vim-textobj-entire',
    event = 'VeryLazy',
    dependencies = 'kana/vim-textobj-user',
  },
  {
    'Julian/vim-textobj-variable-segment',
    event = 'VeryLazy',
    dependencies = 'kana/vim-textobj-user',
  },
}
