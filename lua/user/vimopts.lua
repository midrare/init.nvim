local M = {}

M.setup = function()
  -- NOTE nocompatible must come before all other options
  -- https://stackoverflow.com/a/8932857
  vim.opt.compatible = false

  -- vim.g.airline_theme = "solarized"
  -- vim.g.airline_solarized_bg = "light"

  vim.opt.breakindent = true
  vim.opt.colorcolumn = '+1'
  vim.opt.expandtab = true
  vim.opt.formatoptions = 'l'
  vim.opt.linebreak = true
  vim.opt.mouse = ''
  vim.opt.number = true
  vim.opt.scrolloff = 2
  vim.opt.shiftwidth = 4
  vim.opt.showbreak = '↪'
  vim.opt.sidescrolloff = 4
  vim.opt.signcolumn = 'yes'
  vim.opt.smartindent = true
  vim.opt.splitbelow = true
  vim.opt.splitright = true
  vim.opt.tabstop = 4
  vim.opt.textwidth = 80
  vim.opt.undofile = true
  vim.opt.updatetime = 300
  vim.opt.wrap = true
  vim.opt.encoding = 'utf-8'

  -- no need for shada when we have sessions
  vim.opt.shada = ""

  -- https://github.com/nvim-tree/nvim-tree.lua?tab=readme-ov-file#setup
  vim.g.loaded_netrw = 1
  vim.g.loaded_netrwPlugin = 1

  -- if vim.fn.exists("+shellslash") ~= 0 then
  --   vim.opt.shellslash = true
  -- end

  vim.cmd('set fillchars+=eob:\\ ')

  -- => akinsho/toggleterm.nvim
  vim.opt.hidden = true

  vim.cmd('set guioptions-=e')

  vim.cmd('set sessionoptions-=blank')
  vim.cmd('set sessionoptions-=buffers')
  vim.cmd('set sessionoptions-=curdir')
  vim.cmd('set sessionoptions-=folds')
  vim.cmd('set sessionoptions-=globals')
  vim.cmd('set sessionoptions-=help')
  vim.cmd('set sessionoptions-=localoptions')
  vim.cmd('set sessionoptions-=options')
  vim.cmd('set sessionoptions-=resize')
  vim.cmd('set sessionoptions-=terminal')
  vim.cmd('set sessionoptions-=winpos')
  vim.cmd('set sessionoptions-=winsize')
  vim.cmd('set sessionoptions+=globals')
  vim.cmd('set sessionoptions+=tabpages')

  for _, dir in pairs(vim.opt.undodir:get()) do
    vim.fn.mkdir(dir, 'p')
  end

  -- disable undo history for temp files
  -- prevents logging of passwd changes, etc.
  vim.cmd([[
    augroup vimrc_disable_undo_history_for_tmp_files
      autocmd!
      autocmd BufWritePre /tmp/*,~/Appdata/Local/Temp/* setlocal noundofile
    augroup END
  ]])

  -- redirects programmatic invocations of $VISUAL to this instance of nvim
  if vim.fn.has('nvim') == 1 and vim.fn.executable('nvr') == 1 then
    vim.env.VISUAL = 'nvr -cc tabedit --remote-wait +"set bufhidden=wipe"'
  end

  if vim.env.TMUX == nil or vim.env.TMUX == '' then
    if vim.fn.has('nvim') == 1 then
      vim.env.NVIM_TUI_ENABLE_TRUE_COLOR = 1
    end
    if vim.fn.has('termguicolors') == 1 then
      vim.opt.termguicolors = true
    end
  end

  vim.api.nvim_create_autocmd({ 'TextYankPost' }, {
    callback = vim.hl.on_yank,
    desc = 'flash highlights on yanked text range',
  })

  -- https://github.com/neovim/neovim/issues/16646
  -- vim.opt.shell = "C:/Program Files/nu/bin/nu.exe"

  -- XXX no idea what this does but nvim-cmp wants it according to its readme
  vim.opt.completeopt = 'menu,menuone,noselect'
end

return M
