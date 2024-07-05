local modulename = "depgraph.lua"

local M = {}

M.DependencyGraph = {}

function M.DependencyGraph:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  self._nodes = {}
  self._node_to_dependencies = {}
  return o
end

function M.DependencyGraph:add_node(n)
  if self._node_to_dependencies[n] == nil then
    self._node_to_dependencies[n] = {}
    table.insert(self._nodes, n)
  end
end

function M.DependencyGraph:add_dependency(node, dependency)
  if self._node_to_dependencies[node] == nil then
    self._node_to_dependencies[node] = {}
    table.insert(self._nodes, node)
  end

  if self._node_to_dependencies[dependency] == nil then
    self._node_to_dependencies[dependency] = {}
    table.insert(self._nodes, dependency)
  end

  local dependencies = self._node_to_dependencies[node]
  table.insert(dependencies, dependency)
end

function M.DependencyGraph:_resolve_order(n, resolved, unresolved, ordered)
  unresolved[n] = true
  if self._node_to_dependencies[n] ~= nil then
    for _, dep in ipairs(self._node_to_dependencies[n]) do
      if resolved[dep] == nil or not resolved[dep] then
        if unresolved[dep] ~= nil and unresolved[dep] then
          vim.notify(
            'Circular reference detected: ' .. n .. ' -> ' .. dep,
            vim.log.levels.ERROR,
            { title = modulename }
          )
        else
          self:_resolve_order(dep, resolved, unresolved, ordered)
        end
      end
    end
  end
  resolved[n] = true
  unresolved[n] = nil

  table.insert(ordered, n)
end

function M.DependencyGraph:resolve_order()
  local ordered = {}
  local resolved = {}
  local unresolved = {}

  for _, n in ipairs(self._nodes) do
    self:_resolve_order(n, resolved, unresolved, ordered)
  end

  return ordered
end

return M
