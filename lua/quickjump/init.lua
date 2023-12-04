local modulename, _ = ...
local os = require('os')

local charpicker = require(modulename .. '.charpicker')
local paths = require(modulename .. '.path')
local state = require(modulename .. '.state')
local matcher = require(modulename .. '.matcher')

local M = {}

local function show_picker(basedir, targets)
  local chosen = nil
  local picker = charpicker.CharPicker:new()
  local chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
  local used = {}

  picker:set_display_attrs({ 'handle', 'type', 'filename' })
  picker:set_display_attr_hls({
    handle = 'String',
    type = 'Directory',
    filename = 'Comment',
  })

  for lbl, targets_ in pairs(targets) do
    for _, target in ipairs(targets_) do
      local basename = paths.basename(target)
      local filename = paths.abspath(target, basedir)
      if vim.fn.filereadable(filename) ~= 0 then
        local handle = lbl:sub(1, 1)
        while used[handle] do
          local idx = chars:find(handle)
          idx = (idx % #chars) + 1
          handle = chars[idx]
        end
        used[handle] = true

        picker:append_item({
          handle = handle,
          filename = basename,
          filepath = filename,
          type = lbl,
        })
      end
    end
  end

  chosen = picker:prompt()
  if chosen and vim.fn.filereadable(chosen.filepath) then
    vim.cmd('edit ' .. vim.fn.escape(chosen.filepath, ' '))
  end
end

M.setup = function(opts) end

M.get = function(path)
  local path_ = nil
  if path then
    local cwd = vim.fn.getcwd()
    path_ = paths.normpath(path)
    path_ = paths.abspath(path_, cwd)
  else
    local buf = vim.fn.expand('%:p')
    path_ = paths.normcase(buf)
  end

  if path_ ~= nil and #path > 0 then
    return matcher.match(path_)
  end
end

M.choose = function(path)
  local path_ = nil
  if path then
    local cwd = vim.fn.getcwd()
    path_ = paths.normpath(path)
    path_ = paths.abspath(path_, cwd)
  else
    local buf = vim.fn.expand('%:p')
    path_ = paths.normcase(buf)
  end

  if path_ ~= nil and #path_ > 0 then
    local targets = matcher.match(path_)
    if targets ~= nil then
      local basedir = paths.dirname(path_)
      return show_picker(basedir, targets)
    end
  end
end

return M
