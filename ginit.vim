lua << EOF
local path_sep = "/"
if vim.fn.has("win32") >= 1 then
  path_sep = "\\"
end

local vim_linux_exe = "vim"
local vim_win_exe = "vim.exe"
local nvim_linux_exe = "nvim"
local nvim_win_exe = "nvim.exe"

local function read_json(filepath)
  local filepath = filepath:gsub("[\\/]", path_sep)

  local fd = vim.loop.fs_open(filepath, "r", 438)
  if not fd then
    return nil
  end

  local stat = vim.loop.fs_fstat(fd)
  if not stat then
    return nil
  end

  local data = vim.loop.fs_read(fd, stat.size, 0)
  vim.loop.fs_close(fd)
  if not data then
    return nil
  end

  local decoded = vim.fn.json_decode(data)
  if not decoded then
    return nil
  end

  return decoded
end

local function is_nvim_dir(dir)
  return dir
      and (vim.fn.filereadable(dir .. path_sep .. vim_linux_exe) > 0
      or vim.fn.filereadable(dir .. path_sep .. vim_win_exe) > 0
      or vim.fn.filereadable(dir .. path_sep .. nvim_linux_exe) > 0
      or vim.fn.filereadable(dir .. path_sep .. nvim_win_exe) > 0)
end

if not vim.g.gui_initialized then
  vim.g.gui_initialized = true

  local config = vim.tbl_deep_extend(
    'force',
    { guifont = "monospace:h10" },
    read_json(vim.fn.stdpath("config") .. path_sep .. "config.json") or {},
    read_json(vim.fn.stdpath("data") .. path_sep .. "config.json") or {}
  )

  if is_nvim_dir(vim.fn.getcwd(-1, -1)) then
    vim.cmd("cd ~")
  end

  if vim.fn.exists(":GuiFont") > 0 then
    vim.cmd("silent! GuiFont! " .. vim.fn.escape(config.guifont, " "))
  else
    vim.cmd("silent! set guifont=" .. vim.fn.escape(config.guifont, " "))
  end

  if vim.fn.exists(":GuiPopupmenu") > 0 then
    -- disable gui popup menu
    vim.cmd("silent! GuiPopupmenu 0")
  end

  if vim.fn.exists(":GuiTabline") > 0 then
    -- disable gui tabline
    vim.cmd("silent! GuiTabline 0")
  end

  if vim.g.fvim_loaded then
    vim.cmd("silent! FVimCursorSmoothMove v:true")
    vim.cmd("silent! FVimCursorSmoothBlink v:true")
    vim.cmd("silent! FVimFontAutoSnap v:true")
    vim.cmd("silent! FVimFontNoBuiltinSymbols v:true")
  end

  if vim.fn.exists(":GuiAdaptiveColor") > 0 then
    vim.cmd("silent! GuiAdaptiveColor 1")
  end

  if vim.fn.exists(":GuiAdaptiveFont") > 0 then
    vim.cmd("silent! GuiAdaptiveFont 1")
  end

  if vim.fn.exists(":GuiRenderLigatures") > 0 then
    vim.cmd("silent! GuiRenderLigatures 0")
  end
end
EOF
