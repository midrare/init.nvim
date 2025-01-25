return {
  'rgroli/other.nvim',
  lazy = true,
  config = function(m, opts)
    require('other-nvim').setup({
      mappings = {
        'c',
        {
          pattern = "(.*)%.([ch])(pp)?$",
          target = "/tests/%1_test.c%3",
          context = "test",
        }
      },
    })
  end,
}
