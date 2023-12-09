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


local default = {
  asterisk = {
    cmd = {},
  },
  colorscheme = nil,
  commenter = {
    cmd = {},
  },
  edit = {
    cmd = {},
  },
  exploder = {
    cmd = {},
  },
  filetree = {
    cmd = {},
  },
  fileoverview = {
    cmd = {},
  },
  formatter = {
    cmd = {},
  },
  greeter = { cmd = {} },
  jump = {
    cmd = {},
  },
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
    server_config = { ['*'] = {} },
  },
  taskrunner = {
    cmd = {},
  },
  root_markers = {
    '.bzr', '.git', '.hg', '.root', '.svn', '_darcs', 'package.json',
  },
  ignored_filetypes = {
    'NvimTree', 'neo-tree', 'aerial', 'Outline', 'quickfix', 'qf', 'prompt', "SidebarNvim",
  },
  ignored_buftypes = { 'quickfix' },
  quickfix = {
    cmd = {},
  },
  tabline = {
    cmd = {},
    ignored_filetypes = {},
  },
  telescope = {
    cmd = {},
    extensions = {},
  },
  terminal = {
    cmd = {},
    exe = get_term_exe(),
  },
  workspace = {
    cmd = {},
  },
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


local file = vim.fn.stdpath('config') .. '/' .. 'config.json'
local config = {}

config = vim.tbl_deep_extend('force', default, read_json(file) or {})

return config
