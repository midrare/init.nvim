local modulename, _ = ...
local moduleroot = modulename:gsub('(.+)%..+', '%1')

local paths = require(moduleroot .. '.path')

local M = {}

local default = {
  current_icon = '•',
}

M.plugin_name = 'quickjump'
M.plugin_datadir = vim.fn.stdpath('data') .. paths.sep() .. 'quickjump'
M.data_filename = '.quickjump.json'
M.root_markers = {
  '.root',
  '.git',
  '.hg',
  '_darcs',
  '.bzr',
  '.svn',
  'package.json',
}

M.verbose = 1

return M
