vim.g.polyglot_disabled = vim.list_extend(
  vim.g.polyglot_disabled or {},
  { 'c', 'cpp', 'markdown', 'norg', 'lua', 'ftdetect' })

local specs = {
  { 'dylon/vim-antlr', lazy = true },
  { 'bfrg/vim-cpp-modern', lazy = true },
  { 'ErichDonGubler/vim-nushell', lazy = true },
  {
    'nvim-treesitter/nvim-treesitter',
    event = "VeryLazy",
    config = function(m, opts)
      require('nvim-treesitter.configs').setup(opts)
    end,
    opts = {
      ensure_installed = {
        'bash',
        'bibtex',
        'c',
        'c_sharp',
        'cmake',
        'commonlisp',
        'cpp',
        'css',
        'd',
        'dockerfile',
        'erlang',
        'fish',
        'gdscript',
        'go',
        'html',
        'java',
        'javascript',
        'json',
        'latex',
        'lua',
        'make',
        'ninja',
        'norg',
        'ocaml',
        'org',
        'perl',
        'php',
        'python',
        'r',
        'regex',
        'rst',
        'ruby',
        'rust',
        'scss',
        'toml',
        'typescript',
        'vim',
        'yaml',
        'zig',
      },
      indent = { enable = true },
      highlight = { enable = true, additional_vim_regex_highlighting = true },
      matchup = { enable = true, include_match_words = true },
    }
  },
  { 'nvim-treesitter/nvim-treesitter-textobjects', event = "VeryLazy" },
  {
    'tpope/vim-markdown',
    event = "VeryLazy",
    config = function(m, opts)
      vim.cmd([[
        augroup markdown_formatoptions
        autocmd!
        autocmd BufEnter,BufRead,BufNewFile *.md setlocal formatoptions-=tc
        augroup END
      ]])
    end
  },
  {
    'nvim-neorg/neorg',
    event = "VeryLazy",
    dependencies = 'nvim-lua/plenary.nvim',
    config = function(m, opts)
      require("neorg").setup(opts)
      -- https://github.com/nvim-lua/plenary.nvim#plenaryfiletype
      require('plenary.filetype').add_file('norg')
    end,
    opts = {
      load = {
        ['core.defaults'] = {},
        ['core.dirman'] = {},
        ['core.concealer'] = {},
        ['core.manoeuvre'] = {},
        ['core.qol.toc'] = {},
        ['core.export'] = {},
      },
    }
  },
}

if not vim.g.vscode or vim.g.vscode == '' or vim.g.vscode == 0 then
  -- language pack for Vim
  table.insert(specs, { 'sheerun/vim-polyglot' })
end

return specs
