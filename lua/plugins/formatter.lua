local modulename = "formatter.lua"

local config = require("user.config")

config.keymaps = config.keymaps or {}
config.keymaps.n = config.keymaps.n or {}
config.keymaps.x = config.keymaps.x or {}


local function format_buf(opts)
  opts = opts or {}

  local ftype = vim.bo.filetype
  local fmtt = vim.g["formatter_" .. ftype]
  if fmtt ~= nil then
    opts = vim.tbl_deep_extend('force', {
      formatters = { fmtt },
    }, opts)
  end

  local conform = prequire('conform')
  if conform then
    conform.format(opts)
  end
end


local function format_range(args)
  local range = nil
  if args.count >= 0 then
    local end_line = vim.api.nvim_buf_get_lines(
      0,
      args.line2 - 1,
      args.line2,
      true
    )[1]
    range = {
      start = { args.line1, 0 },
      ["end"] = { args.line2, end_line:len() },
    }
  end

  if format_buf ~= nil then
    format_buf({ range = range })
  end
end


config.keymaps.n['<leader>ro'] = {
  label = 'reformat',
  cmd = format_buf,
}


return {
  'stevearc/conform.nvim',
  lazy = true,
  cmd = { 'Format' },
  init = function()
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    vim.api.nvim_create_user_command(
      "Format",
      format_range,
      { range = true }
    )
  end,
  opts = {
    default_format_opts = {
      async = true,
      lsp_format = 'fallback',
      stop_after_first = true,
    },
    notify_no_formatters = false,
    formatters_by_ft = {
      c = { 'clang-format' },
      cmake = { 'cmakeformat' },
      cpp = { 'clang-format' },
      java = { 'clang-format' },
      javascript = { 'prettier' },
      json = { 'prettier' },
      kotlin = { 'ktlint' },
      html = { 'prettier' },
      lua = { 'stylua' },
      python = { 'black' },
      ruby = { 'rubocop' },
      rust = { 'rustfmt' },
      sh = { 'shfmt' },
      toml = { 'taplo' },
      typescript = { 'biome' },
      yaml = { 'prettier' },
      zig = { 'zigfmt' },
    },
  },
}
