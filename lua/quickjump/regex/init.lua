local moduleroot, _ = ...

local old_require = require
require = function(m)
  return old_require(moduleroot .. '.' .. m)
end
local M = require('re')
require = old_require

return M
