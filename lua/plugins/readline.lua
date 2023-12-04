return {
  'assistcontrol/readline.nvim',
  lazy = true,
  config = function(m, opts)
    local readline = require("readline")
    -- vim.keymap.set("!", "<C-k>", readline.kill_line)
    vim.keymap.set('!', '<C-u>', function()
      require("readline").backward_kill_line()
    end)
    vim.keymap.set('!', '<M-d>', function()
      require("readline").kill_word()
    end)
    vim.keymap.set('!', '<M-BS>', function()
      require("readline").backward_kill_word()
    end)
    vim.keymap.set('!', '<C-w>', function()
      require("readline").unix_word_rubout()
    end)
    vim.keymap.set('!', '<C-d>', '<Delete>') -- delete-char
    vim.keymap.set('!', '<C-h>', '<BS>') -- backward-delete-char
    vim.keymap.set('!', '<C-a>', function()
      require("readline").beginning_of_line()
    end)
    vim.keymap.set('!', '<C-e>', function()
      require("readline").end_of_line()
    end)
    vim.keymap.set('!', '<M-f>', function()
      require("readline").forward_word()
    end)
    vim.keymap.set('!', '<M-b>', function()
      require("readline").backward_word()
    end)
    vim.keymap.set('!', '<C-f>', '<Right>') -- forward-char
    vim.keymap.set('!', '<C-b>', '<Left>') -- backward-char
    vim.keymap.set('!', '<C-n>', '<Down>') -- next-line
    vim.keymap.set('!', '<C-p>', '<Up>') -- previous-line
  end
}
