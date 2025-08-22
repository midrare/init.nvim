local moduletitle = 'init.lua'

local path_sep = '/'
if vim.fn.has('win32') >= 1 then
  path_sep = '\\'
end

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

local function read_json(file)
  if vim.fn.filereadable(file) <= 0 then
    return nil
  end

  local handle = io.open(file, "r")
  if not handle then
    return nil
  end

  local data = handle:read("*a")
  handle:close()

  if not data then
    return nil
  end

  local json_ok, json_obj = pcall(vim.fn.json_decode, data)
  if not json_ok then
    return nil
  end

  return json_obj
end

math.randomseed(os.time())

local config = require('user.config')

require('user.vimopts').setup()
require('user.keybinds').setup()

bootstrap_package_manager()

require('lazy').setup({
  { 'midrare/hookspace.nvim', dev = true },
  { 'midrare/altarfile.nvim', dev = true },
  { 'midrare/regex.nvim', dev = true },
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

while true do
  local themery = read_json(
    vim.fn.stdpath("data")
    .. path_sep
    .. "themery"
    .. path_sep
    .. "state.json"
  ) or {}

  if themery and themery.colorscheme then
    local color_ok, _ = pcall(vim.cmd, 'colorscheme ' .. themery.colorscheme)
    if color_ok then
      break
    else
      vim.notify(
        "Failed to load color scheme " .. themery.colorscheme,
        vim.log.levels.ERROR,
        { title = moduletitle }
      )
    end
  end

  if config.colorscheme then
    local color_ok, _ = pcall(vim.cmd, 'colorscheme ' .. config.colorscheme)
    if color_ok then
      break
    else
      vim.notify(
        "Failed to load color scheme " .. config.colorscheme,
        vim.log.levels.ERROR,
        { title = moduletitle }
      )
    end
  end
  break
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
