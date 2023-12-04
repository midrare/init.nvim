local config = require("user.config")
config.ignored_filetypes = config.ignored_filetypes or {}
config.ignored_buftypes = config.ignored_buftypes or {}

return {
  {
    'NMAC427/guess-indent.nvim',
    event = "VeryLazy",
    opts = function(m, opts)
      opts.filetype_exclude = opts.filetype_exclude or {}
      opts.buftype_exclude = opts.buftype_exclude or {}
      vim.list_extend(opts.filetype_exclude, config.ignored_filetypes or {})
      vim.list_extend(opts.buftype_exclude, config.ignored_buftypes or {})
    end
  }
}
