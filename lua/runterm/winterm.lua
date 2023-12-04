local modulename, _ = ...
local moduleroot = modulename:gsub('(.+)%..+', '%1')
local ini = require(moduleroot .. '.ini')

local M = {}

local path_sep = '/'
if vim.fn.has('win32') > 0 then
  path_sep = '\\'
end

local script_dir =
  debug.getinfo(1).source:match('@?(.*)[\\/]+'):gsub('[\\/]+', path_sep)
local script_path = (script_dir .. path_sep .. 'winterm.ahk'):gsub(
  '[\\/]+',
  '\\'
)

local function is_quoted(s)
  return s:match('^".*"$') or s:match('^".*"$')
end

local function to_quoted(s)
  s = tostring(s)
  if not is_quoted(s) then
    s = '"' .. s:gsub('"', '"') .. '"'
  end
  return s
end

local function run_in_terminal(cmd, opts)
  if type(cmd) == 'string' then
    cmd = { cmd }
  end
  opts = opts or {}

  local term_cmd = { script_path }
  local term_pid = -1

  if opts.term_pid and opts.term_pid >= 0 then
    table.insert(term_cmd, '--reuse-pid')
    table.insert(term_cmd, opts.term_pid)
  end

  table.insert(term_cmd, '--reuse-scan')

  if opts.open_in_dir then
    local dir = nil
    if type(opts.open_in_dir) == 'string' then
      dir = opts.open_in_dir
    elseif type(opts.open_in_dir) == 'function' then
      dir = opts.open_in_dir()
    end
    if dir then
      table.insert(term_cmd, '--open-in-dir')
      table.insert(term_cmd, dir)
    end
  end

  if opts.open_with_profile then
    table.insert(term_cmd, '--open-with-profile')
    table.insert(term_cmd, opts.open_with_profile)
  end

  if opts.open_with_cmd then
    table.insert(term_cmd, '--open-with-cmd')
    table.insert(term_cmd, opts.open_with_cmd)
  end

  if opts.run_in_dir then
    local dir = nil
    if type(opts.run_in_dir) == 'string' then
      dir = opts.run_in_dir
    elseif type(opts.run_in_dir) == 'function' then
      dir = opts.run_in_dir()
    end
    if dir then
      table.insert(term_cmd, '--run-in-dir')
      table.insert(term_cmd, dir)
    end
  end

  local output_file = os.tmpname()
  table.insert(term_cmd, '--ini-out')
  table.insert(term_cmd, output_file)

  if cmd then
    table.insert(term_cmd, '--')
    for _, arg in ipairs(cmd) do
      table.insert(term_cmd, arg)
    end
  end

  -- https://stackoverflow.com/a/53455533
  local term_cmd_str = ''
  for i, s in ipairs(term_cmd) do
    if i > 1 then
      term_cmd_str = term_cmd_str .. ' '
    end
    term_cmd_str = term_cmd_str .. to_quoted(s)
  end
  term_cmd_str = '"' .. term_cmd_str .. '"'

  pcall(os.execute, term_cmd_str)

  local output = ini.load(output_file)
  pcall(os.remove, output_file)

  if
    output
    and output.process
    and output.process.pid
    and tonumber(output.process.pid)
  then
    term_pid = math.floor(output.process.pid or -1)
  end

  return term_pid
end

M.run_in_terminal = function(cmd, opts)
  return run_in_terminal(cmd, opts)
end

M.focus_terminal = function(opts)
  return run_in_terminal(nil, opts)
end

return M
