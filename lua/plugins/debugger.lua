local config = require("user.config")

config.keymaps = config.keymaps or {}
config.keymaps.n = config.keymaps.n or {}
config.keymaps.x = config.keymaps.x or {}

config.keymaps.n['<leader>b'] = {
  label = 'debug',
}

config.keymaps.n['<leader>bb'] = {
  label = 'breakpoint',
  cmd = function()
    require('dap').toggle_breakpoint()
  end,
}
config.keymaps.n['<leader>bB'] = {
  label = 'logpoint',
  cmd = function()
    require('dap').toggle_breakpoint(nil, nil,
      vim.fn.input('Log point message: '))
  end,
}
config.keymaps.n['<leader>bc'] = {
  label = 'continue',
  cmd = function()
    require('dap').continue()
  end,
}
config.keymaps.n['<leader>bo'] = {
  label = 'step over',
  cmd = function()
    require('dap').step_over()
  end,
}
config.keymaps.n['<leader>bi'] = {
  label = 'step into',
  cmd = function()
    require('dap').step_into()
  end,
}
config.keymaps.n['<leader>bu'] = {
  label = 'step out',
  cmd = function()
    require('dap').step_out()
  end,
}
config.keymaps.n['<leader>bp'] = {
  label = 'inspect',
  cmd = function()
    require('dap').repl.open()
  end,
}
config.keymaps.n['<leader>br'] = {
  label = 're-run',
  cmd = function()
    require('dap').run_last()
  end,
}
config.keymaps.n['<leader>bm'] = {
  label = 'debugger ui',
  cmd = function()
    require('dapui').toggle()
  end,
}


vim.fn.sign_define(
  'DapBreakpoint',
  { text = '', texthl = '', linehl = '', numhl = '' }
)
vim.fn.sign_define(
  'DapBreakpointCondition',
  { text = '', texthl = '', linehl = '', numhl = '' }
)
vim.fn.sign_define(
  'DapLogPoint',
  { text = '󱍥', texthl = '', linehl = '', numhl = '' }
)
vim.fn.sign_define(
  'DapStopped',
  { text = '', texthl = '', linehl = '', numhl = '' }
)
vim.fn.sign_define(
  'DapBreakpointRejected',
  { text = '', texthl = '', linehl = '', numhl = '' }
)


return {
  {
    'mfussenegger/nvim-dap',
    lazy = true,
    config = function(m, opts)
      local path_sep = '/'
      if vim.fn.has('win32') > 0 then
        path_sep = '\\'
      end

      local vscode = vim.fn.expand('~')
        .. path_sep
        .. '.vscode'
        .. path_sep
        .. 'extensions'
      require("dap").configurations.cpp = {
        id = 'cppdbg',
        type = 'executable',
        command = vscode
          .. path_sep
          .. 'ms-vscode.cpptools-1.12.4-win32-x64'
          .. path_sep
          .. 'debugAdapters'
          .. path_sep
          .. 'bin'
          .. path_sep
          .. 'OpenDebugAD7.exe',
        options = {
          detached = false,
        },
      }
    end
  },
  {
    'rcarriga/nvim-dap-ui',
    event = "VeryLazy",
    config = true,
    dependencies = { 'mfussenegger/nvim-dap' },
  },
  {
    'theHamsta/nvim-dap-virtual-text',
    event = "VeryLazy",
    config = true,
    dependencies = { 'mfussenegger/nvim-dap' },
  }
}
