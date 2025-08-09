local modulename = 'keybinds.lua'
local M = {}

local is_macro_recording = false
local macro_reg = 'm'

local uppercase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
local lowercase = 'abcdefghijklmnopqrstuvwxyz'
local digits = '1234567890'

local function random_str(alphabet, len)
  if len <= 0 then
    return ''
  end

  local s = ''
  for _ = 1, len do
    local idx = math.random(1, #alphabet)
    s = s .. alphabet:sub(idx, idx)
  end

  return s
end


local function include_guard(name)
  if not name or name:match('^%s*$') then
    local _ = nil
    name, _ = vim.api.nvim_buf_get_name(0)
        :gsub('[\\/]+$', '')
        :gsub('^.*[\\/]+', '')
        :gsub('^%.*([^%.]+).*', '%1')
  end

  local name, _ = name
    :upper()
    :gsub('[^a-zA-Z0-9]', '_')
    :gsub('^[^a-zA-Z0-9]+', '')
    :gsub('[^a-zA-Z0-9]+$', '')
  local guard = name .. '_H' .. random_str(digits, 8)


  -- delete existing include guard if any
  local lines = vim.api.nvim_buf_get_lines(
    0, 0, vim.api.nvim_buf_line_count(0), false)
  if lines == nil then
    return
  end

  local ifndef_idx = nil
  local define_idx = nil
  for i, line in ipairs(lines) do
    if line:match('^%s*$') then
      -- skip blank line
    elseif line:match('^%s*//.*') then
      -- skip comment line
    elseif not ifndef_idx and line:match('^%s*#ifndef%s+.-_H%d+%s*$') then
      ifndef_idx = i
    elseif ifndef_idx and line:match('^%s*#define%s+.-_H%d+%s*$') then
      define_idx = i
      break
    else
      break
    end
  end

  local endif_idx = nil
  for i=#lines, 1, -1 do
    local line = lines[i]
    if line:match('^%s*$') then
      -- skip blank line
    elseif line:match('^%s*//.*') then
      -- skip comment line
    elseif line:match('^%s*#endif%s*//%s*.-_H%d+%s*$') then
      endif_idx = i
      break
    else
      break
    end
  end

  if ifndef_idx ~= nil and define_idx ~= nil and endif_idx ~= nil then
    vim.api.nvim_buf_set_lines(0, ifndef_idx-1, define_idx, false, {
      '#ifndef ' .. guard,
      '#define ' .. guard,
    })
    vim.api.nvim_buf_set_lines(0, endif_idx-1, endif_idx, false, {
      '#endif  // ' .. guard,
    })
  else
    vim.api.nvim_buf_set_lines(0, 0, 0, true, {
      '#ifndef ' .. guard,
      '#define ' .. guard,
      '',
    })
    vim.api.nvim_buf_set_lines(0, -1, -1, true, {
      '',
      '#endif  // ' .. guard,
    })
  end
end

local function select_lsp_client_name(method, opts)
  local opts = vim.tbl_deep_extend('force', {}, opts or {})

  local client_names = {}
  for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
    if client:supports_method(method) then
      table.insert(client_names, client.name)
    end
  end
  table.sort(client_names)

  if type(opts.priority) == 'string' then
    if vim.list_contains(client_names, opts.priority) then
      return opts.priority
    end
  elseif type(opts.priority) == 'table' then
    for _, client_name in ipairs(opts.priority) do
      if vim.list_contains(client_names, client_name) then
        return client_name
      end
    end
  end

  if opts.select ~= nil and opts.select and #client_names > 1 then
    local state = {}
    state.client_name = nil
    vim.ui.select(client_names, { prompt = 'LSP client' }, function(client)
      state.client_name = client
    end)

    return state.client_name
  end

  if
    opts.select == nil
    and #client_names > 1
    and (opts.warn == nil or opts.warn)
  then
    vim.notify(
      'More than one LSP client supporting '
        .. method
        .. ' found. Defaulting to first client ('
        .. client_names[1]
        .. '). '
        .. 'To show client picker, pass { opts.select = true }.',
      vim.log.levels.WARN,
      { title = modulename }
    )
  end

  if client_names ~= nil and #client_names >= 1 then
    return client_names[1]
  end

  return nil
end

local function lsp(fn, method, opts)
  local opts = vim.tbl_deep_extend('force', {}, opts or {})

  local function exec(...)
    local client_name = select_lsp_client_name(method, opts)
    opts.warn = false

    local args = { { name = client_name } }
    local nargs = select('#', ...)

    if nargs > 0 and type(select(nargs, ...)) == 'table' then
      -- HACK last argument is not guaranteed to be opts table
      args = { n = select('#', ...), ... }
      args[#args] = vim.tbl_deep_extend('force', opts, args[#args])
      args[#args].name = client_name
    elseif nargs > 0 then
      args = { n = select('#', ...), ... }
      table.insert(args, { name = client_name })
    end

    fn((unpack or table.unpack)(args))
  end

  return exec
end

local function bake(fn, ...)
  local args = {}

  if select('#', ...) > 0 then
    args = { n = select('#', ...), ... }
  end

  return function()
    ---@diagnostic disable-next-line: undefined-global
    fn((unpack or table.unpack)(args))
  end
end

M.setup = function()
  local config = require('user.config')

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

  config.keymaps.n['grn'] = {
    label = 'rename',
    cmd = lsp(bake(vim.lsp.buf.rename, nil), 'textDocument/rename')
      or vim.lsp.buf.rename,
  }
  config.keymaps.n['<leader>rr'] = {
    label = 'rename',
    cmd = lsp(bake(vim.lsp.buf.rename, nil), 'textDocument/rename')
      or vim.lsp.buf.rename,
  }
  config.keymaps.n['<leader>ra'] = {
    label = 'code action',
    cmd = lsp(vim.lsp.buf.code_action, 'textDocument/codeAction')
      or vim.lsp.buf.code_action,
  }

  config.keymaps.n['<leader>ri'] = {
    label = 'include guard',
    cmd = include_guard,
  }

  config.keymaps.n['<leader>rp'] = {
    label = 'random digits',
    cmd = function()
      local s = random_str(digits, 10)
      vim.api.nvim_paste(s, true, -1)
    end,
  }
  config.keymaps.n['<leader>rP'] = {
    label = 'random alnums',
    cmd = function()
      local s = random_str(lowercase .. uppercase .. digits, 10)
      vim.api.nvim_paste(s, true, -1)
    end,
  }

  config.keymaps.n['<leader>P'] = {
    label = 'restart lsp',
    cmd = '<cmd>LspRestart<cr>',
  }

  config.keymaps.n[' e'] = {
    label = 'definition',
    cmd = lsp(
      vim.lsp.buf.definition,
      'textDocument/definition',
      { reuse_win = true }
    ) or vim.lsp.buf.definition,
  }

  config.keymaps.n[' q'] = {
    label = 'inline docs',
    cmd = lsp(vim.lsp.buf.hover, 'textDocument/hover') or vim.lsp.buf.hover,
  }

  config.keymaps.n[' s'] = {
    label = 'signature',
    cmd = lsp(vim.lsp.buf.signature_help, 'signatureHelpProvider')
      or vim.lsp.buf.signature_help,
  }

  config.keymaps.n[' t'] = {
    label = 'type',
    cmd = lsp(vim.lsp.buf.type_definition, 'textDocument/typeDefinition')
      or vim.lsp.buf.type_definition,
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
        vim.cmd.normal({ '@' .. macro_reg, bang = true })
      else
        vim.cmd.normal({ vim.v.count1 .. '@' .. macro_reg, bang = true })
      end
    end,
  }
  config.keymaps.n['Q'] = {
    label = 'record',
    cmd = function()
      if not is_macro_recording then
        vim.cmd.normal({ 'q' .. macro_reg, bang = true })
        is_macro_recording = true
      else
        vim.cmd.normal({ 'q', bang = true })
        is_macro_recording = false
      end
    end,
  }
end

return M
