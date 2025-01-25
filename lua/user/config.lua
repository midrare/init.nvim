local function get_term_exe()
  -- TODO detect the existence of the shell exe in a location-agnostic way
  if vim.fn.executable('C:\\Program Files\\nu\\bin\\nu.exe') == 1 then
    return '"C:\\Program Files\\nu\\bin\\nu.exe" -l'
  end

  if vim.fn.executable('nu') == 1 then
    return 'nu -l'
  end

  if vim.fn.executable('bash') == 1 then
    return 'bash'
  end

  return nil
end


local base = {
  colorscheme = nil,
  keymaps = {
    n = {
      ['<leader>ro'] = {
        label = 'reformat',
        cmd = function()
          vim.lsp.buf.format()
        end
      }
    },
    x = {}
  },
  lsp = {
    ensure_installed = {},
    on_init = {},
    on_attach = {},
    server_config = {},
  },
  root_markers = {
    '.bzr',
    '.git',
    '.hg',
    '.root',
    '.svn',
    'package.json',
    '_darcs',
  },
  ignored_filetypes = {
    'NvimTree', 'neo-tree', 'aerial', 'Outline', 'quickfix', 'qf', 'prompt', "SidebarNvim",
  },
  ignored_buftypes = { 'quickfix' },
  telescope = { extensions = {} },
  terminal = { exe = get_term_exe() },
  max_downloads = -1,
}



local function read_json(file)
  if vim.fn.filereadable(file) <= 0 then
    return nil
  end

  local handle = io.open(file, "r")
  if not handle then
    return nil
  end

  local data = handle:read("*a")
  handle:close()

  if not data then
    return nil
  end

  local json_ok, json_obj = pcall(vim.fn.json_decode, data)
  if not json_ok then
    return nil
  end

  return json_obj
end


local bundled = vim.fn.stdpath('config') .. '/' .. 'config.json'
local user = vim.fn.stdpath('data') .. '/' .. 'config.json'

local config = vim.tbl_deep_extend(
  'force',
  base,
  read_json(bundled) or {},
  read_json(user) or {}
)

return config
