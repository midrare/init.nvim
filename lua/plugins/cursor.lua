return {
  'ggandor/leap.nvim',
  event = "VeryLazy",
  config = function(m, opts)
    require("leap").add_default_mappings()
  end
}
