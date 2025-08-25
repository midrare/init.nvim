local config = require('user.config')

config.keymaps = config.keymaps or {}
config.keymaps.n = config.keymaps.n or {}
config.keymaps.x = config.keymaps.x or {}

config.keymaps.n['<leader>d'] = {
  label = 'debug',
}

config.keymaps.n['<leader>db'] = {
  label = 'breakpoint',
  cmd = function()
    require('dap').toggle_breakpoint()
  end,
}
config.keymaps.n['<leader>dB'] = {
  label = 'logpoint',
  cmd = function()
    require('dap').toggle_breakpoint(
      nil,
      nil,
      vim.fn.input('Log point message: ')
    )
  end,
}
config.keymaps.n['<leader>dc'] = {
  label = 'continue',
  cmd = function()
    require('dap').continue()
  end,
}
config.keymaps.n['<leader>do'] = {
  label = 'step over',
  cmd = function()
    require('dap').step_over()
  end,
}
config.keymaps.n['<leader>di'] = {
  label = 'step into',
  cmd = function()
    require('dap').step_into()
  end,
}
config.keymaps.n['<leader>du'] = {
  label = 'step out',
  cmd = function()
    require('dap').step_out()
  end,
}
config.keymaps.n['<leader>dp'] = {
  label = 'inspect',
  cmd = function()
    require('dap').repl.open()
  end,
}
config.keymaps.n['<leader>dr'] = {
  label = 're-run',
  cmd = function()
    require('dap').run_last()
  end,
}
config.keymaps.n['<leader>dm'] = {
  label = 'debugger ui',
  cmd = function()
    require('dap-view').open()
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
      require('dap').configurations.cpp = {
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
    end,
  },
  {
    'igorlfs/nvim-dap-view',
    lazy = true,
    init = function()
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'dap-*',
        callback = function(args)
          for _, key in ipairs({
            '<tab>',
            '<c-tab>',
            '<right>',
            ']b',
            ']v',
            '}',
          }) do
            vim.keymap.set('n', key, function()
              require('dap-view').navigate({
                count = vim.v.count1,
                wrap = true,
              })
            end, { buffer = args.buf, desc = 'next view' })
          end

          for _, key in ipairs({
            '<s-tab>',
            '<c-s-tab>',
            '<left>',
            '[b',
            '[v',
            '{',
          }) do
            vim.keymap.set('n', key, function()
              require('dap-view').navigate({
                count = -vim.v.count1,
                wrap = true,
              })
            end, { buffer = args.buf, desc = 'prev view' })
          end
        end,
      })
    end,
    config = true,
  },
}
