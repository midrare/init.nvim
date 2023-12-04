local moduleroot, _ = ...

local depgraph = require(moduleroot .. '.depgraph')
local reloadmodule = require(moduleroot .. '.reloadmodule')

local M = {}

local path_sep = '/'
if vim.fn.has('win32') >= 1 then
  path_sep = '\\'
end

local function read_json(filepath)
  local filepath = filepath:gsub('[\\/]', path_sep)

  local fd = vim.loop.fs_open(filepath, 'r', 438)
  if not fd then
    return nil
  end

  local stat = vim.loop.fs_fstat(fd)
  if not stat then
    return nil
  end

  local data = vim.loop.fs_read(fd, stat.size, 0)
  vim.loop.fs_close(fd)
  if not data then
    return nil
  end

  local decoded = vim.fn.json_decode(data)
  if not decoded then
    return nil
  end

  return decoded
end

local function require_module(name, force_reload)
  local status_ok, ret
  if not force_reload then
    status_ok, ret = pcall(require, name)
  else
    status_ok, ret = pcall(reloadmodule.reload, name)
  end

  if not status_ok then
    vim.notify(
      'require("' .. name .. '") failed.',
      vim.log.levels.ERROR,
      { title = moduleroot }
    )
    if ret then
      vim.notify(ret, vim.log.levels.TRACE, { title = moduleroot })
      ret = nil
    end
  elseif ret == nil then
    vim.notify(
      'require("' .. name .. '") returned nil',
      vim.log.levels.ERROR,
      { title = moduleroot }
    )
  end

  return ret or nil
end

local function import_module(name, module, state)
  if module.import ~= nil then
    local status_ok, status_msg = pcall(module.import, state)
    if not status_ok then
      vim.notify(
        'Failed to import module "' .. name .. '".',
        vim.log.levels.ERROR,
        { title = moduleroot }
      )
      if status_msg then
        vim.notify(status_msg, vim.log.levels.TRACE, { title = moduleroot })
      end
    end
  end
end

local function setup_module(name, module, state)
  if module.setup ~= nil then
    local status_ok, status_msg = pcall(module.setup, state)
    if not status_ok then
      vim.notify(
        'Failed to setup module "' .. name .. '".',
        vim.log.levels.ERROR,
        { title = moduleroot }
      )
      if status_msg then
        vim.notify(status_msg, vim.log.levels.TRACE, { title = moduleroot })
      end
    end
  end
end

local function get_feature_providers(names, name_to_module)
  local feature_to_provider_names = {}

  for _, name in ipairs(names) do
    local module = name_to_module[name]

    if
      module
      and module.provides_features ~= nil
      and module.provides_features
    then
      local features = { unpack(module.provides_features) }
      table.sort(features)
      for _, feature in ipairs(features) do
        if feature_to_provider_names[feature] == nil then
          feature_to_provider_names[feature] = {}
        end
        local provider_names = feature_to_provider_names[feature]
        table.insert(provider_names, name)
      end
    end
  end

  return feature_to_provider_names
end

local function get_setup_before_all(names, name_to_module)
  local setup_before_all = {}

  for _, name in ipairs(names) do
    local module = name_to_module[name]

    if
      module
      and module.before_features ~= nil
      and vim.tbl_contains(module.before_features, '*')
    then
      if
        module.after_features ~= nil
        and not vim.tbl_isempty(module.after_features)
      then
        vim.notify(
          'Module "'
            .. name
            .. '" needs to load before "*" '
            .. 'but contradictorily has items it needs to load after',
          vim.log.levels.ERROR,
          { title = moduleroot }
        )
      end
      table.insert(setup_before_all, name)
    end
  end

  return setup_before_all
end

local function get_setup_after_all(names, name_to_module)
  local setup_after_all = {}

  for _, name in ipairs(names) do
    local module = name_to_module[name]

    if
      module
      and module.after_features ~= nil
      and vim.tbl_contains(module.after_features, '*')
    then
      if
        module.before_features ~= nil
        and not vim.tbl_isempty(module.before_features)
      then
        vim.notify(
          'Module "'
            .. name
            .. '" needs to load after "*" '
            .. 'but contradictorily has items it needs to load before',
          vim.log.levels.ERROR,
          { title = moduleroot }
        )
      end
      table.insert(setup_after_all, name)
    end
  end

  return setup_after_all
end

local function resolve_dependency_order(names, name_to_module)
  local deps = depgraph.DependencyGraph:new()

  local feature_to_provider_names = get_feature_providers(names, name_to_module)
  local setup_before_all = get_setup_before_all(names, name_to_module)
  local setup_after_all = get_setup_after_all(names, name_to_module)

  for _, name in ipairs(names) do
    local module = name_to_module[name]

    if module then
      if module.before_features ~= nil then
        for _, feature in ipairs(module.before_features) do
          if feature ~= '*' then
            if feature_to_provider_names[feature] ~= nil then
              local provider_names =
                { unpack(feature_to_provider_names[feature]) }
              table.sort(provider_names)
              for _, provider_name in ipairs(provider_names) do
                deps:add_dependency(provider_name, name)
              end
            end
          end
        end
      end

      if module.after_features ~= nil then
        for _, feature in ipairs(module.after_features) do
          if feature ~= '*' then
            if feature_to_provider_names[feature] ~= nil then
              local provider_names =
                { unpack(feature_to_provider_names[feature]) }
              table.sort(provider_names)
              for _, provider_name in ipairs(provider_names) do
                deps:add_dependency(name, provider_name)
              end
            end
          end
        end
      end

      if module.requires_features ~= nil then
        for _, feature in ipairs(module.requires_features) do
          if feature_to_provider_names[feature] == nil then
            vim.notify(
              'Module "'
                .. name
                .. '" requires feature "'
                .. feature
                .. '" but no providers found',
              vim.log.levels.ERROR,
              { title = moduleroot }
            )
          else
            for _, provider_name in ipairs(feature_to_provider_names[feature]) do
              deps:add_dependency(name, provider_name)
            end
          end
        end
      end

      deps:add_node(name)
    end
  end

  local resolved = deps:resolve_order()
  local ordered = {}
  local skip = {}

  for _, name in ipairs(setup_before_all) do
    if not skip[name] then
      table.insert(ordered, name)
      skip[name] = true
    end
  end

  for _, name in ipairs(setup_after_all) do
    skip[name] = true
  end

  for _, name in ipairs(resolved) do
    if not skip[name] then
      table.insert(ordered, name)
      skip[name] = true
    end
  end

  for _, name in ipairs(setup_after_all) do
    table.insert(ordered, name)
  end

  return ordered
end

function M.load(names, opts)
  local default_opts = { reload = false, config = {} }
  opts = vim.tbl_deep_extend('force', default_opts, opts or {})
  names = names or {}
  if type(names) ~= 'table' then
    names = { names }
  end

  local name_to_module = {}

  for _, name in ipairs(names) do
    name_to_module[name] = require_module(name, opts.reload)
  end

  for _, name in ipairs(names) do
    local module = name_to_module[name]
    if module then
      import_module(name, module, opts.config)
    end
  end

  local resolved_order = resolve_dependency_order(names, name_to_module)
  for _, name in ipairs(resolved_order) do
    local module = name_to_module[name]
    if module then
      setup_module(name, module, opts.config)
    end
  end
end

return M
