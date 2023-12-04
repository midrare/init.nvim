local config = require("user.config")

config.ignored_buftypes = config.ignored_buftypes or {}
config.ignored_filetypes = config.ignored_filetypes or {}

table.insert(config.ignored_buftypes, "quickfix")
table.insert(config.ignored_filetypes, "NvimTree")
table.insert(config.ignored_filetypes, "neo-tree")
table.insert(config.ignored_filetypes, "undotree")
table.insert(config.ignored_filetypes, "gundo")

return {
  {
    'kwkarlwang/bufresize.nvim',
    event = 'VimResized',
    config = true,
  }
}
