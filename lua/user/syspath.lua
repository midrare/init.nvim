local M = {}

local gow_reg_key = 'HKEY_LOCAL_MACHINE\\SOFTWARE\\WOW6432Node\\Gow'

M.setup = function()
  if vim.fn.has('win32') > 0 then
    local platform = require('luamisc.platform')
    local _, _, gow_path = platform.read_winreg_value(gow_reg_key)
    if gow_path and gow_path.value then
      local syspath = vim.fn.getenv('Path')
      vim.fn.setenv('Path', syspath .. ';' .. gow_path.value .. '\\bin')
    end
  end
end

return M
