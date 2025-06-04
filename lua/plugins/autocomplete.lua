return {
  {
    'hrsh7th/nvim-cmp',
    opts = function(m, opts)
      local function scroll(count)
        local cmp = require('cmp')
        if cmp.visible() then
          if not cmp.get_selected_entry() then
            cmp.select_next_item()
          end
          if count >= 0 then
            cmp.select_next_item({ count = count })
          else
            cmp.select_prev_item({ count = -count })
          end
        else
          cmp.scroll_docs(count)
        end
      end

      local has_words_before = function()
        local line, col = (unpack or table.unpack)(
          vim.api.nvim_win_get_cursor(0)
        )
        return col ~= 0
            and (
              vim.api
              .nvim_buf_get_lines(0, line - 1, line, true)[1]
              :sub(col, col)
              :match('%s') == nil
            )
      end

      -- buffers ""
      -- paths ""
      -- tree_sitter ""
      -- snippets ""
      -- lsp ""
      -- tabnine ""
      -- tags ""
      -- third_party ""
      -- tmux ""

      local cmp = require('cmp')
      return {
        preselect = cmp.PreselectMode.None,
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end,
        },
        sources = {
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'codeium' },
          { name = 'buffer',  { sorting = { priority_weight = 0.75 } } },
          { name = 'path' },
        },
        formatting = {
          format = require('lspkind').cmp_format({
            mode = 'symbol',
            maxwidth = 50,
          }),
        },
        mapping = cmp.mapping.preset.insert({
          ['<c-b>'] = cmp.mapping(function(fallback)
            scroll(-16)
          end),
          ['<c-f>'] = cmp.mapping(function(fallback)
            scroll(16)
          end),
          ['<c-u>'] = cmp.mapping(function(fallback)
            scroll(-8)
          end),
          ['<c-d>'] = cmp.mapping(function(fallback)
            scroll(8)
          end),
          ['<c-spc>'] = cmp.mapping.complete(),
          ['<c-e>'] = cmp.mapping.abort(),
          ['<esc>'] = cmp.mapping(function(fallback)
            cmp.abort()
            fallback()
          end),
          ['<cr>'] = cmp.mapping.confirm({ select = false }),
          ['<tab>'] = cmp.mapping(function(fallback)
            local function check_backspace()
              local col = vim.fn.col('.') - 1
              return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s')
            end

            local _, luasnip = pcall(require, 'luasnip')
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip and luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-tab>'] = cmp.mapping(function(fallback)
            local _, luasnip = pcall(require, 'luasnip')
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip and luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
        }),
      }
    end,
  },
  dependencies = {
    { 'hrsh7th/cmp-buffer' },
    { 'hrsh7th/cmp-path' },
    { 'hrsh7th/cmp-cmdline' },
    { 'onsails/lspkind.nvim' },
  },
  {
    'L3MON4D3/LuaSnip',
    lazy = true,
    dependencies = { 'rafamadriz/friendly-snippets' },
    config = function(m, opts)
      require('luasnip.loaders.from_vscode').lazy_load()
    end,
  },
  { 'hrsh7th/cmp-nvim-lsp' },
  {
    "Exafunction/windsurf.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp",
    },
    config = function()
      require("codeium").setup({})
    end,
  }
}
