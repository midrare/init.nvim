local modulename, _ = ...
local moduleroot = modulename:gsub('(.+)%..+', '%1')

local M = {}

local function _assign(old, new, k)
  local otype = type(old[k])
  local ntype = type(new[k])
  if
    (otype == 'thread' or otype == 'userdata')
    or (ntype == 'thread' or ntype == 'userdata')
  then
    print('warning: old or new attr ' .. k .. ' type be thread or userdata')
  end
  old[k] = new[k]
end

local function _replace(old, new, repeat_tbl)
  if repeat_tbl[old] then
    return
  end
  repeat_tbl[old] = true

  local dellist = {}
  for k, v in pairs(old) do
    if not new[k] then
      table.insert(dellist, k)
    end
  end
  for _, v in ipairs(dellist) do
    old[v] = nil
  end

  for k, v in pairs(new) do
    if not old[k] then
      old[k] = new[k]
    else
      if type(old[k]) ~= type(new[k]) then
        _assign(old, new, k)
      else
        if type(old[k]) == 'table' then
          _replace(old[k], new[k], repeat_tbl)
        else
          _assign(old, new, k)
        end
      end
    end
  end
end

function M.reload(mod)
  if not package.loaded[mod] then
    local m = require(mod)
    return m
  end

  local old = package.loaded[mod]
  package.loaded[mod] = nil
  local new = require(mod)

  if type(old) == 'table' and type(new) == 'table' then
    local repeat_tbl = {}
    _replace(old, new, repeat_tbl)
  end

  package.loaded[mod] = old
  return old
end

local functor = {}
M.functor = functor
functor.__index = functor

function functor.new(func, mod, ...)
  local self = {}
  self.func = func
  self.mod = mod
  local arg_len = select('#', ...)
  local arg1 = select(1, ...)
  if arg1 or arg_len > 1 then
    self.args = table.pack(...)
  end
  setmetatable(self, functor)
  return self
end

function functor:get()
  if self.mod then
    return self.mod[self.func]
  else
    return self.func
  end
end

function functor:call(...)
  local func = self:get()
  if self.args then
    return func(table.unpack(self.args), ...)
  else
    return func(...)
  end
end

return M
