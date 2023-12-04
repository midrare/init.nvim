local modulename, _ = ...
local moduleroot = (modulename or 'quickjump'):gsub('(.+)%..+', '%1')

local files = require(moduleroot .. '.file')
local paths = require(moduleroot .. '.path')
local regex = require(moduleroot .. '.regex')
local state = require(moduleroot .. '.state')

local M = {}

local function is_project_root_dir(path)
  if state.root_markers then
    for _, m in ipairs(state.root_markers) do
      local root_marker = paths.join(path, m)
      if
        vim.fn.filereadable(root_marker) ~= 0
        or vim.fn.isdirectory(tostring(root_marker)) ~= 0
      then
        return true
      end
    end
  end

  local parent = paths.dirname(path)
  if not parent or #parent <= 0 or parent == path then
    return true
  end

  return false
end

local function get_parent_dirs(path, stop)
  assert(type(path) == 'string', 'expected path of type string')
  assert(stop == nil or type(stop) == 'string' or type(stop) == 'function')
  if type(stop) == 'string' then
    stop = stop:gsub('[\\/]', '/')
  end

  local dir = path:gsub('[\\/]', '/')
  if vim.fn.filereadable(dir) ~= 0 then
    dir = paths.dirname(dir)
  end

  local dirs = {}

  while dir and #dir > 0 do
    table.insert(dirs, dir)
    if dir == stop or (type(stop) == 'function' and stop(dir)) then
      break
    end
    local parent = paths.dirname(dir)
    if not parent or parent == dir then
      break
    end
    dir = parent
  end

  return dirs
end

local function substitute(obj, replaces)
  assert(type(replaces) == 'table', 'expected replaces of type table')

  if type(obj) == 'string' then
    for pat, repl in pairs(replaces) do
      obj = obj:gsub(pat, repl)
    end
  elseif type(obj) == 'table' then
    obj = vim.tbl_deep_extend('force', {}, obj)
    for k, v in pairs(obj) do
      obj[k] = substitute(v, replaces)
    end
  end

  return obj
end

local function generate_builtin_groups(rootdir, mapdir, filename)
  assert(type(rootdir) == 'string', 'expected root dir of type string')
  assert(type(mapdir) == 'string', 'expected map dir of type string')
  assert(type(filename) == 'string', 'expected filename of type string')

  return {
    ['{filename}'] = filename,
    ['{basename}'] = paths.basename(filename),
    ['{dirname}'] = paths.dirname(filename),
    ['{filestem}'] = paths.filestem(filename),
    ['{fileext}'] = paths.fileext(filename),
    ['{rootdir}'] = rootdir,
    ['{mapdir}'] = mapdir,
  }
end

local function generate_num_groups(matches)
  assert(type(matches) == 'table', 'expected matches of type table')

  local groups = {}
  for i, group in ipairs(matches) do
    groups['{$' .. i .. '}'] = group
  end

  return groups
end

local function match_pattern(source, pattern)
  assert(type(source) == 'string', 'expected source to be type string')
  assert(type(pattern) == 'string', 'expected pattern to be type string')

  local compiled_pattern = regex.compile(pattern)
  local matches = compiled_pattern:execute(source)

  if matches and #matches > 0 then
    return generate_num_groups(matches)
  end

  return nil
end

local function read_maps_file(dir)
  local filepath = paths.join(dir, state.data_filename)
  local maps = {}
  if vim.fn.filereadable(filepath) ~= 0 then
    maps = files.read_json(filepath)
  end
  return maps
end

local function match(filename)
  assert(type(filename) == 'string', 'path must be of type string')
  assert(paths.isabs(filename), 'path must be absolute path')

  local matches = {}

  local parent_dirs = get_parent_dirs(filename, is_project_root_dir)
  local root_dir = parent_dirs[#parent_dirs]

  for _, map_dir in pairs(parent_dirs) do
    local builtin_groups = generate_builtin_groups(root_dir, map_dir, filename)

    for _, map in ipairs(read_maps_file(map_dir)) do
      local source = substitute(map.source or filename, builtin_groups)
      local num_groups = match_pattern(source, map.pattern)

      if num_groups ~= nil then
        local targets = substitute(map.targets, builtin_groups)
        targets = substitute(targets, num_groups)
        matches = vim.tbl_deep_extend('keep', matches, targets)
      end
    end
  end

  return matches
end

M.match = function(filename)
  assert(type(filename) == 'string', 'path must be of type string')
  assert(paths.isabs(filename), 'path must be absolute path')
  return match(filename)
end

return M
