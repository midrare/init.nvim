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

local normal = {
  noremap = true,
  silent = true,
  callback = delete_current_buffer,
}

local force = {
  noremap = true,
  silent = true,
  callback = function()
    delete_current_buffer(true)
  end,
}

return {
  'kazhala/close-buffers.nvim',
  lazy = true,
  config = true,
  keys = {
    { '<C-w>e', normal, desc = 'close' },
    { '<C-w><C-e>', normal, desc = 'close' },
    { '<C-w>E', force, desc = 'force close' },
    { '<C-w><C-E>', force, desc = 'force close' },
  }
}
