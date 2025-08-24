return {
  -- more pairings for the % key
  'monkoose/matchparen.nvim',
  event = "VeryLazy",
  init = function()
    vim.g.loaded_matchit = 1
  end,
  config = true,
}
