local moduletitle = 'init.lua'

function prequire(plugin)
  local name = plugin:match('^.+[\\/](.+)') or plugin
  local is_ok, mod = pcall(require, name)
  if not is_ok then
    local msg = 'Failed to require("' .. name .. '")'
    vim.notify(msg, vim.log.levels.ERROR, { title = moduletitle })
    return nil
  end
  return mod or {}
end


local config = require('user.config')

local function bootstrap_package_manager()
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable", -- latest stable release
      lazypath,
    })
  end
  vim.opt.rtp:prepend(lazypath)
end

require("user.vimopts").setup()
require("user.keybinds").setup()

bootstrap_package_manager()

require("lazy").setup({
  { "midrare/hookspace.nvim", branch = 'dev', dev = true },
  { import = "plugins" },
}, {
  dev = { path = "~/Projects" },
  git = { timeout = 300 },
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
