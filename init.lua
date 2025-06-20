local moduletitle = 'init.lua'

---@diagnostic disable-next-line: lowercase-global
function prequire(plugin)
  local name = plugin:match('^.+[\\/](.+)') or plugin
  local is_ok, mod = pcall(require, plugin)
  if not is_ok then
    local msg = 'Failed to require("' .. name .. '")'
    vim.notify(msg, vim.log.levels.ERROR, { title = moduletitle })
    return nil
  end
  return mod or {}
end

local function bootstrap_package_manager()
  local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
  if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
      'git',
      'clone',
      '--filter=blob:none',
      'https://github.com/folke/lazy.nvim.git',
      '--branch=stable', -- latest stable release
      lazypath,
    })
  end
  vim.opt.rtp:prepend(lazypath)
end

math.randomseed(os.time())

local config = require('user.config')

require('user.vimopts').setup()
require('user.keybinds').setup()

bootstrap_package_manager()

require('lazy').setup({
  { 'midrare/hookspace.nvim', dev = true },
  { 'midrare/altarfile.nvim', dev = true },
  { import = 'plugins' },
}, {
  dev = { path = config.devpath, fallback = true },
  git = { timeout = 300 },
  change_detection = { enabled = false, notify = false },
  concurrency = (
    config
    and config.max_downloads
    and config.max_downloads >= 1
    and config.max_downloads
  ) or nil,
})

if config.colorscheme then
  vim.cmd('colorscheme ' .. config.colorscheme)
end

-- "https://github.com/neovim/neovim/issues/16646
-- "let &shell = ""C:/Program Files/nu/bin/nu.exe""

-- not all GUIs read ginit.vim; force it to be read
vim.api.nvim_create_autocmd({ 'GUIEnter', 'VimEnter' }, {
  callback = function()
    local p = vim.fn.stdpath('config'):gsub('\\', '/') .. '/' .. 'ginit.vim'
    vim.cmd('exec "source ' .. vim.fn.escape(p, ' ') .. '"')
    return true
  end,
  desc = 'set up gui options',
})
