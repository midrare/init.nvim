local modulename = "keybinds.lua"
local M = {}

local is_macro_recording = false
local macro_reg = 'm'

local uppercase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
local lowercase = "abcdefghijklmnopqrstuvwxyz"
local digits = "1234567890"


local function random_str(alphabet, len)
  if len <= 0 then
    return ''
  end

  local s = ""
  for _ = 1, len do
    local idx = math.random(1, #alphabet)
    s = s .. alphabet:sub(idx, idx)
  end

  return s
end


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

  config.keymaps.n['<leader>rp'] = {
    label = 'random digits',
    cmd = function()
      local s = random_str(digits, 16)
      vim.api.nvim_paste(s, true, -1)
    end,
  }
  config.keymaps.n['<leader>rP'] = {
    label = 'random alnums',
    cmd = function()
      local s = random_str(lowercase .. uppercase .. digits, 16)
      vim.api.nvim_paste(s, true, -1)
    end,
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

  config.keymaps.n['<c-tab>'] = {
    label = 'file jump',
    cmd = function()
      require("other-nvim").open()
    end,
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

  config.keymaps.n['q'] = {
    label = 'playback',
    cmd = function()
      local cnt = vim.v.count
      if cnt <= 0 then
        vim.cmd.normal({ "@" .. macro_reg, bang = true })
      else
        vim.cmd.normal({ vim.v.count1 .. "@" .. macro_reg, bang = true })
      end
    end,
  }
  config.keymaps.n['Q'] = {
    label = 'record',
    cmd = function()
      if not is_macro_recording then
        vim.cmd.normal({ "q" .. macro_reg, bang = true })
        is_macro_recording = true
      else
        vim.cmd.normal({ "q", bang = true })
        is_macro_recording = false
      end
    end,
  }
end

return M
