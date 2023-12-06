local function delete_current_buffer(force)
  if vim.fn.exists(':BDelete') then
    if force == nil or not force then
      vim.cmd([[BDelete this]])
    else
      vim.cmd([[BDelete! this]])
    end
  else
    if force == nil or not force then
      vim.cmd([[bdelete]])
    else
      vim.cmd([[bdelete!]])
    end
  end
end

local normal = function()
  delete_current_buffer()
end

local force = function()
  delete_current_buffer(true)
end

return {
  'kazhala/close-buffers.nvim',
  lazy = true,
  cmd = { "BD", "BDelete" },
  config = true,
  keys = {
    { '<C-w>e', normal, desc = 'close', noremap = true, silent = true },
    { '<C-w><C-e>', normal, desc = 'close', noremap = true, silent = true },
    { '<C-w>E', force, desc = 'force close', noremap = true, silent = true },
    { '<C-w><C-E>', force, desc = 'force close', noremap = true, silent = true },
  }
}
