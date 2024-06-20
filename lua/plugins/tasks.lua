local config = require("user.config")

config.telescope = config.telescope or {}
config.telescope.extensions = config.telescope.extensions or {}
table.insert(config.telescope.extensions, 'asynctasks')

config.keymaps = config.keymaps or {}
config.keymaps.n = config.keymaps.n or {}
config.keymaps.x = config.keymaps.x or {}

config.keymaps.n['<leader>k'] = {
  label = 'last task',
  cmd = '<cmd>AsyncTaskLast<cr>',
}

config.keymaps.n['<leader>K'] = {
  label = 'tasks',
  cmd = '<cmd>Telescope asynctasks all<cr>',
}

vim.g.asyncrun_open = 8
vim.g.asyncrun_rootmarks = { '.git', '.svn', '.root', '.project', '.hg' }
vim.list_extend(vim.g.asyncrun_rootmarks, config.root_markers)


return {
  { 'skywind3000/asynctasks.vim', event = 'VeryLazy' },
  { 'skywind3000/asyncrun.vim', event = 'VeryLazy' },
  { 'GustavoKatel/telescope-asynctasks.nvim', event = 'VeryLazy' },
}
