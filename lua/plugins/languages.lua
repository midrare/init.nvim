local modulename, _ = ...

vim.g.polyglot_disabled = vim.list_extend(
  vim.g.polyglot_disabled or {},
  { 'c', 'cpp', 'markdown', 'norg', 'lua', 'ftdetect' }
)


local specs = {
  { 'dylon/vim-antlr' },
  { 'bfrg/vim-cpp-modern' },
  { 'elkasztano/nushell-syntax-vim' },
  {
    'nvim-treesitter/nvim-treesitter',
    config = function(m, opts)
      require('nvim-treesitter.configs').setup(opts)
      -- WARN https://github.com/nvim-treesitter/nvim-treesitter/issues/3092
      for _, p in ipairs(vim.api.nvim_get_runtime_file('parser/vim.dll', true)) do
        if p:match(".*[\\/]lib[\\/]nvim[\\/]parser[\\/].*") then
          vim.notify(
            "tree-sitter parsers found at " .. p:gsub("[\\/][^\\/]+$", "") .. ". "
            .. "Consider deleting them to avoid an issue with duplicate parsers "
            .. "in tree-sitter. "
            .. "https://github.com/nvim-treesitter/nvim-treesitter/issues/3092",
            vim.log.levels.WARN,
            { title = modulename }
          )
          break
        end
      end
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
        'kotlin',
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
        'vimdoc',
        'yaml',
        'zig',
      },
      indent = { enable = true },
      highlight = { enable = true, additional_vim_regex_highlighting = true },
      matchup = { enable = true, include_match_words = true },
    },
  },
  { 'nvim-treesitter/nvim-treesitter-textobjects' },
  {
    'tpope/vim-markdown',
    config = function(m, opts)
      vim.cmd([[
        augroup markdown_formatoptions
        autocmd!
        autocmd BufEnter,BufRead,BufNewFile *.md setlocal formatoptions-=tc
        augroup END
      ]])
    end,
  },
  {
    'nvim-neorg/neorg',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'vhyrro/luarocks.nvim',
      'nvim-neorg/lua-utils.nvim',
      'pysan3/pathlib.nvim',
    },
    config = function(m, opts)
      require('neorg').setup(opts)
      -- https://github.com/nvim-lua/plenary.nvim#plenaryfiletype
      require('plenary.filetype').add_file('norg')
    end,
    opts = {
      load = {
        ['core.defaults'] = {},
        ['core.dirman'] = {},
        ['core.concealer'] = {},
        ['core.qol.toc'] = {},
        ['core.export'] = {},
      },
    },
  },
}

if not vim.g.vscode or vim.g.vscode == '' or vim.g.vscode == 0 then
  -- language pack for Vim
  table.insert(specs, { 'sheerun/vim-polyglot' })
end

return specs
