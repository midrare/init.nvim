local moduleroot, _ = ...

local linuxterm = require(moduleroot .. '.linuxterm')
local winterm = require(moduleroot .. '.winterm')

local M = {}

local asyncrun_runner_declared = false
local default_config = {
  open_in_dir = nil,
  open_with_profile = nil,
  open_with_cmd = nil,
  run_in_dir = nil,
  term_pid = nil,
}

local config_ = vim.tbl_deep_extend('keep', default_config, {})

local function is_linux()
  return vim.fn.has('unix') > 0
    and vim.fn.has('macunix') <= 0
    and vim.fn.has('win32unix') <= 0
end

local function is_windows()
  return vim.fn.has('win32') > 0
end

function _RunTermAsyncRun(cmd)
  M.run_in_terminal(cmd)
end

M.setup = function(config)
  config = config or {}
  config_ = vim.tbl_deep_extend('force', default_config, config)

  if not asyncrun_runner_declared then
    asyncrun_runner_declared = true
    vim.cmd([[
            function! RuntermAsyncRunRunner(opts)
                let g:MV7BKD19TL = a:opts.cmd
                lua _RunTermAsyncRun(vim.g.MV7BKD19TL)
                unlet g:MV7BKD19TL
            endfunction
            let g:asyncrun_runner = get(g:, "asyncrun_runner", {})
            let g:asyncrun_runner.runterm = function("RuntermAsyncRunRunner")
        ]])
  end
end

M.config = function()
  return vim.tbl_deep_extend('keep', config_, {})
end

M.run_in_terminal = function(cmd, opts)
  opts = opts or {}
  opts = vim.tbl_deep_extend('force', config_, opts)

  if is_linux() then
    linuxterm.run_in_terminal(cmd, opts)
  elseif is_windows() then
    local pid = winterm.run_in_terminal(cmd, opts)
    if pid and pid >= 0 then
      config_.term_pid = pid
    end
  else
    io.stderr:write('Platform not supported\n')
  end
end

M.focus_terminal = function(opts)
  opts = opts or {}
  opts = vim.tbl_deep_extend('force', config_, opts)

  if is_linux() then
    linuxterm.focus_terminal(opts)
  elseif is_windows() then
    local pid = winterm.focus_terminal(opts)
    if pid and pid >= 0 then
      config_.term_pid = pid
    end
  else
    io.stderr:write('Platform not supported\n')
  end
end

return M
