return {
  'rgroli/other.nvim',
  lazy = true,
  config = function(m, opts)
    require('other-nvim').setup({
      mappings = {
        'c',
      },
    })
  end,
}
