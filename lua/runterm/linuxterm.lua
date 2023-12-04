local M = {}

-- use list to maintain order in which patterns are tested
local win_man_to_exe = {
  ['^gnome-session.*pantheon'] = 'pantheon-terminal',
  ['^gnome-session'] = 'gnome-terminal',
  ['^cinnamon-session.*pantheon'] = 'pantheon-terminal',
  ['^cinnamon-session'] = 'gnome-terminal',
  ['^xfce4-session'] = 'xfce4-terminal',
  ['^ksmserver'] = 'konsole',
  ['^lxsession'] = 'lxterminal',
  ['^mate-panel'] = 'mate-terminal',
}

local start_terminal_timeout_secs = 5
local start_terminal_delay_ms = 1000

local last_term_pid = nil

local function detect_linux_default_terminal()
  local terminal = 'xterm'

  local handle = io.popen('ps -eo comm,args 2>/dev/null')
  if handle then
    while true do
      local line = handle:read('*l')
      if not line then
        break
      end
      line = line:gsub('^%s+', ''):gsub('%s+$', '')
      for pat, term in pairs(win_man_to_exe) do
        if line:match(pat) then
          terminal = term
          break
        end
      end
    end
    handle:close()
  end

  return terminal
end

local function get_linux_open_windows()
  local results = {}
  local handle = io.popen('wmctrl -lp 2>/dev/null')
  if handle then
    while true do
      local line = handle:read('*l')
      if not line then
        break
      end
      line = line:gsub('^%s+', ''):gsub('%s+$', '')
      local wid, did, pid, machine, title =
        line:match('([^%s]+)%s+([^%s]+)%s+([^%s]+)' .. '%s+([^%s]+)%s+(.+)%s*')
      local win = {
        window_id = wid,
        desktop_id = tonumber(did),
        process_id = tonumber(pid),
        machine = machine,
        title = title,
      }
      table.insert(results, win)
    end
    handle:close()
  end

  return results
end

local function get_linux_term_windows(term)
  if not term then
    term = detect_linux_default_terminal()
  end

  local results = {}
  local wins = get_linux_open_windows()
  if wins and #wins > 0 then
    local handle = io.popen('ps -eo pid,comm 2>/dev/null')
    if handle then
      handle:read('*l') -- skip header line
      while true do
        local line = handle:read('*l')
        if not line then
          break
        end

        line = line:gsub('^%s+', ''):gsub('%s+$', '')
        local pid, pcomm = line:match('([^%s]+)%s+(.+)%s*')
        if pcomm:match('^' .. term) then
          pid = tonumber(pid)
          for _, win in ipairs(wins) do
            if win.process_id == pid then
              table.insert(results, win)
            end
          end
        end
      end
      handle:close()
    end
  end

  return results
end

local function find_win_by_pid(windows, pid)
  local window = nil
  for _, win in ipairs(windows) do
    if win.process_id == pid then
      window = win
      break
    end
  end
  return window
end

local function start_linux_terminal(term)
  local start = os.time()
  local old_wins = get_linux_term_windows(term)
  local new_wins = {}

  os.execute(term .. ' &>/dev/null &')

  while os.time() - start < start_terminal_timeout_secs do
    new_wins = get_linux_term_windows(term)
    if #new_wins > #old_wins then
      if start_terminal_delay_ms > 0 then
        os.execute('sleep ' .. tostring(start_terminal_delay_ms / 1000))
      end
      break
    end
  end

  while #old_wins > 0 and #new_wins > 1 do
    local do_break = false
    for i, new_win in ipairs(new_wins) do
      for i2, old_win in ipairs(old_wins) do
        if old_win.process_id == new_win.process_id then
          table.remove(new_wins, i)
          table.remove(old_wins, i2)
          do_break = true
          break
        end
        if do_break then
          break
        end
      end
      if do_break then
        break
      end
    end
  end

  return new_wins[1]
end

local function send_input_to_linux_terminal(win_id, cmd)
  if type(cmd) == 'string' then
    cmd = { cmd }
  end

  local args = nil
  if cmd then
    args = ''
    for i, arg in ipairs(cmd) do
      if
        arg:find('%s')
        and not arg:match('^"')
        and not arg:match('"$')
        and not arg:match('^"')
        and not arg:match('"$')
      then
        arg = '"' .. arg:gsub('"', '"') .. '"'
      end
      if #args > 0 then
        args = args .. ' '
      end
      args = args .. arg
    end
    args = '"' .. args:gsub('"', '"') .. '"'
  end

  os.execute('xdotool windowactivate ' .. win_id .. ' --sync &>/dev/null')
  if args then
    os.execute(
      'xdotool type --window '
        .. win_id
        .. ' --delay 0 -- '
        .. args
        .. ' &>/dev/null'
    )
    os.execute('xdotool key --window ' .. win_id .. ' Return &>/dev/null')
  end
end

local function run_in_terminal(cmd, opts)
  opts = opts or {}
  if type(cmd) == 'string' then
    cmd = { cmd }
  end

  local term = detect_linux_default_terminal()

  local win = nil
  local wins = get_linux_term_windows(term)

  if last_term_pid then
    win = find_win_by_pid(wins, last_term_pid)
  end

  if not win then
    if wins and #wins > 0 then
      win = wins[1]
    else
      win = start_linux_terminal(term)
    end
    last_term_pid = win.process_id
  end

  if win then
    send_input_to_linux_terminal(win.window_id, cmd)
  end
end

M.run_in_terminal = function(cmd, opts)
  run_in_terminal(cmd, opts)
end

M.focus_terminal = function(opts)
  run_in_terminal(nil, opts)
end

return M
