return {
  -- { lazy = true } is a special case supported by lazy.nvim
  -- https://lazy.folke.io/spec/lazy_loading#-colorschemes

  -- color scheme packs
  { 'rafi/awesome-vim-colorschemes', priority = 1000, lazy = true },

  { 'folke/tokyonight.nvim', priority = 1000, lazy = true },
  { 'EdenEast/nightfox.nvim', priority = 1000, lazy = true },
  { 'rebelot/kanagawa.nvim', priority = 1000, lazy = true },
  { 'raphamorim/lucario', priority = 1000, lazy = true },
  { 'jsit/toast.vim', priority = 1000, lazy = true },
  { 'bignimbus/pop-punk.vim', priority = 1000, lazy = true },
  { 'sainnhe/everforest', priority = 1000, lazy = true },
  { 'sainnhe/edge', priority = 1000, lazy = true },
  { 'ray-x/aurora', priority = 1000, lazy = true },
  { 'marko-cerovac/material.nvim', priority = 1000, lazy = true },
  { 'savq/melange', priority = 1000, lazy = true },
  { 'Abstract-IDE/Abstract-cs', priority = 1000, lazy = true },
  { 'AhmedAbdulrahman/aylin.vim', priority = 1000, lazy = true },
  { 'heraldofsolace/nisha-vim', priority = 1000, lazy = true },
  { 'mhinz/vim-janah', priority = 1000, lazy = true },
  { 'flrnd/candid.vim', priority = 1000, lazy = true },
  { 'overcache/NeoSolarized', priority = 1000, lazy = true },
  { 'Everblush/everblush.vim', priority = 1000, lazy = true },
  { 'fenetikm/falcon', priority = 1000, lazy = true },
  { 'lunarvim/darkplus.nvim', priority = 1000, lazy = true },
  { 'akai54/2077.nvim', priority = 1000, lazy = true },
  { 'LunarVim/horizon.nvim', priority = 1000, lazy = true },
  { 'vague2k/vague.nvim', priority = 1000, lazy = true },
  { 'zootedb0t/citruszest.nvim', priority = 1000, lazy = true },
  { 'savq/melange-nvim', priority = 1000, lazy = true },
  {
    'pineapplegiant/spaceduck',
    priority = 1000,
    lazy = true,
    config = function(m, opts)
      vim.cmd([[
        if exists("+termguicolors")
          let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
          let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
          set termguicolors
        endif

        let g:airline_theme = "spaceduck"

        if !exists("g:lightline")
          let g:lightline = {}
        endif
        let g:lightline["colorscheme"] = "spaceduck"

        if !exists("g:lualine")
          let g:lualine = {}
        endif
        if !has_key(g:lualine, "options")
          let g:lualine["options"] = {}
        endif
        let g:lualine["options"]["theme"] = "spaceduck"
      ]])
    end,
  },
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    lazy = true,
    init = function(m)
      vim.g.catppuccin_flavour = 'mocha'
    end,
    opts = {
      integrations = {
        nvimtree = { show_root = true },
        lsp_trouble = true,
        which_key = true,
      },
    },
  },
  {
    'maxmx03/fluoromachine.nvim',
    priority = 1000,
    lazy = true,
    config = true,
  },
  {
    'zaldih/themery.nvim',
    lazy = true,
    cmd = "Themery",
    init = function()
      vim.g.themery = 1
    end,
    opts = {
      themes = {
        '2077',
        '256_noir',
        'abstract',
        'afterglow',
        'alduin',
        'anderson',
        'angr',
        'apprentice',
        'archery',
        'atom',
        'aurora',
        'aylin',
        'ayu',
        'candid',
        'carbonized-dark',
        'carbonized-light',
        'catppuccin',
        'challenger_deep',
        'citruszest',
        'darkplus',
        'deep-space',
        'deus',
        'dogrun',
        'edge',
        'everblush',
        'everforest',
        'falcon',
        'flattened_dark',
        'flattened_light',
        'fluoromachine',
        'focuspoint',
        'fogbell',
        'fogbell_light',
        'fogbell_lite',
        'github',
        'gotham',
        'gotham256',
        'gruvbox',
        'happy_hacking',
        'horizon',
        'hybrid',
        'hybrid_material',
        'hybrid_reverse',
        'iceberg',
        'janah',
        'jellybeans',
        'kanagawa',
        'lightning',
        'lucario',
        'lucid',
        'lucius',
        'material',
        'materialbox',
        'melange',
        'meta5',
        'minimalist',
        'molokai',
        'molokayo',
        'mountaineer',
        'mountaineer-grey',
        'mountaineer-light',
        'NeoSolarized',
        'nightfox',
        'nisha',
        'nord',
        'OceanicNext',
        'OceanicNextLight',
        'oceanic_material',
        'one',
        'one-dark',
        'onedark',
        'onehalfdark',
        'onehalflight',
        'orange-moon',
        'orbital',
        'PaperColor',
        'paramount',
        'parsec',
        'pink-moon',
        'pop-punk',
        'purify',
        'pyte',
        'rdark-terminal2',
        'scheakur',
        'seoul256',
        'seoul256-light',
        'sierra',
        'snow',
        'solarized8',
        'solarized8_flat',
        'solarized8_high',
        'solarized8_low',
        'sonokai',
        'space-vim-dark',
        'spacecamp',
        'spacecamp_lite',
        'spaceduck',
        'stellarized',
        'sunbather',
        'tender',
        'termschool',
        'toast',
        'tokyonight',
        'twilight256',
        'two-firewatch',
        'vague',
        'wombat256mod',
        'yellow-moon',
      },
    },
  },
}
