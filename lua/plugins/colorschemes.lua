return {
  -- { lazy = true } is a special case supported by lazy.nvim
  -- https://lazy.folke.io/spec/lazy_loading#-colorschemes

  -- creates highlight groups for color schemes that don't support native LSP
  { 'folke/lsp-colors.nvim', priority = 1000, lazy = true },

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
  { 'adisen99/codeschool.nvim', priority = 1000, lazy = true },
  { 'aswathkk/DarkScene.vim', priority = 1000, lazy = true },
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
    end
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
    }
  },
  {
    'maxmx03/fluoromachine.nvim',
    priority = 1000,
    lazy = true,
    config = true,
  }
}
