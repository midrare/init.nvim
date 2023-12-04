local modulename, _ = ...
local M = {}

M.after_features = { '*' }
M.provides_features = { 'key-binds' }


M.setup = function()
  local config = require("user.config")

  config.keymaps = config.keymaps or {}
  config.keymaps.n = config.keymaps.n or {}
  config.keymaps.x = config.keymaps.x or {}

  config.keymaps.n['<leader>'] = { label = 'file' }
  config.keymaps.n['<leader>r'] = { label = 'refactor' }

  config.keymaps.n['[g'] = {
    label = 'prev diagnostic',
    cmd = vim.diagnostic.goto_prev,
  }
  config.keymaps.n[']g'] = {
    label = 'next diagnostic',
    cmd = vim.diagnostic.goto_next,
  }

  config.keymaps.n['<leader>o'] = {
    label = 'branches',
    cmd = '<cmd>Telescope git_branches<cr>',
  }

  config.keymaps.n['<leader>rr'] = {
    label = 'rename',
    cmd = vim.lsp.buf.rename,
  }
  config.keymaps.n['<leader>ra'] = {
    label = 'code action',
    cmd = vim.lsp.buf.code_action,
  }

  config.keymaps.n[' e'] = {
    label = 'definition',
    cmd = function()
      vim.lsp.buf.definition({ reuse_win = true })
    end,
  }

  config.keymaps.n[' q'] = {
    label = 'inline docs',
    cmd = vim.lsp.buf.hover,
  }

  config.keymaps.n[' s'] = {
    label = 'signature',
    cmd = vim.lsp.buf.signature_help,
  }

  config.keymaps.n[' t'] = {
    label = 'type',
    cmd = vim.lsp.buf.type_definition,
  }

  config.keymaps.n['<c-space>'] = {
    label = 'file jump',
    cmd = function()
      require('quickjump').choose()
    end,
  }

  config.keymaps.n['<leader>k'] = {
    label = 'tasks',
    cmd = '<cmd>Telescope overseer<cr>',
  }

  config.keymaps.n['<F11>'] = {
    label = 'fullscreen',
    cmd = function()
      vim.cmd([[
        let s:fullscreen_flag = 0
        if has("nvim")
          silent! FVimToggleFullScreen
          if s:fullscreen_flag == 0
            silent! call GuiWindowFullScreen(1)
            let s:fullscreen_flag = 1
            let g:neovide_fullscreen = 1
            silent! NvuiFullscreen v:true
          else
            silent! call GuiWindowFullScreen(0)
            let s:fullscreen_flag = 0
            let g:neovide_fullscreen = 0
            silent! NvuiFullscreen v:false
          endif
        endif
      ]])
    end,
  }
end

return M
