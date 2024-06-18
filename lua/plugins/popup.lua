local config = require("user.config")

config.keymaps = config.keymaps or {}
config.keymaps.n = config.keymaps.n or {}
config.keymaps.x = config.keymaps.x or {}

config.keymaps.n['<c-w><enter>'] = {
  cmd = function()
    local popup_id = require("detour").Detour()
    if not popup_id then
      return
    end

    vim.keymap.set('n', '<esc>', function()
      pcall(vim.api.nvim_win_close, popup_id, true)
    end)
  end,
  label = 'popup',
}

config.keymaps.n['<c-w>.'] = {
  cmd = function()
    local popup_id = require("detour").DetourCurrentWindow()
    if not popup_id then
      return
    end

    vim.keymap.set('n', '<esc>', function()
      pcall(vim.api.nvim_win_close, popup_id, true)
    end)
  end,
  label = 'popup small',
}

return {
  "carbon-steel/detour.nvim",
  lazy = true,
}
