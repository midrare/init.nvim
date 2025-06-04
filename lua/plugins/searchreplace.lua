local config = require('user.config')

config.keymaps = config.keymaps or {}
config.keymaps.n = config.keymaps.n or {}
config.keymaps.x = config.keymaps.x or {}


config.keymaps.n['<leader>rt'] = {
  label = 'replace',
  cmd = function()
    require('grug-far').grug_far()
  end,
}

config.keymaps.x['<leader>rt'] = {
  label = 'replace',
  cmd = function()
    require('grug-far').with_visual_selection()
  end,
}


config.ignored_filetypes = config.ignored_filetypes or {}
table.insert(config.ignored_filetypes, 'grug-far')


local state = { bufnum = -1 }

return {
  'MagicDuck/grug-far.nvim',
  lazy = true,
  init = function(m)
    vim.api.nvim_create_user_command('GrugFarPopup', function(params)
      local detour_ok, detour = pcall(require, "detour")
      if detour_ok and detour ~= nil then
        local popup_id = detour.Detour()
        if not popup_id then
          return
        end

        vim.bo.bufhidden = 'hide'
        vim.bo.buflisted = false
        vim.keymap.set('n', '<esc>', function()
          pcall(vim.api.nvim_win_close, popup_id, true)
        end)
      else
        vim.cmd('vsplit')
        local win_id = vim.api.nvim_get_current_win()

        vim.bo.bufhidden = 'hide'
        vim.bo.buflisted = false
        vim.keymap.set('n', '<esc>', function()
          pcall(vim.api.nvim_win_close, win_id, true)
        end)
      end
    end, { nargs = 0, range = true })
  end,
  opts = {
    transient = false,
    -- windowCreationCommand = 'GrugFarPopup',
    keymaps = {
      abort = '<C-c>',
      close = false,
      gotoLocation = false,
      help = false,
      historyAdd = false,
      historyOpen = false,
      openLocation = false,
      openNextLocation = false,
      openPrevLocation = false,
      pickHistoryEntry = false,
      previewLocation = false,
      qflist = false,
      refresh = false,
      replace = "<C-Enter>",
      swapEngine = false,
      swapReplacementInterpreter = false,
      syncLine = false,
      syncLocations = false,
      toggleShowCommand = false,
    },
  }
}
