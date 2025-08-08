return {
  {
    'goolord/alpha-nvim',
    dependencies = {
      'kyazdani42/nvim-web-devicons',
      'nvim-lua/plenary.nvim',
    },
    opts = function(m, opts)
      local banner = {
        [[                               __                ]],
        [[  ___     ___    ___   __  __ /\_\    ___ ___    ]],
        [[ / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\  ]],
        [[/\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \ ]],
        [[\ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\]],
        [[ \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/]],
        [[                                                 ]],
      }

      local platform = require('luamisc.platform')

      local nvim_ver, nvim_rel = platform.nvim_version()
      if nvim_ver then
        table.insert(
          banner,
          string.rep(
            ' ',
            #banner[#banner] - (#nvim_ver + ((nvim_rel and #nvim_rel) or 0)) - 1
          )
            .. nvim_ver
            .. ' '
            .. (nvim_rel or '')
        )
      end

      local max_section_width = 35
      local max_section_items = 5

      local plenary_path = require('plenary.path')
      local dashboard = require('alpha.themes.dashboard')

      local paths = require('luamisc.paths')

      local function get_web_devicon(filename)
        local nwd = require('nvim-web-devicons')
        local ext = paths.fileext(filename)
        return nwd.get_icon(filename, ext, { default = true })
      end

      local function create_file_button(filename, shortcut, label, cmd)
        local ico_txt
        local fb_hl = {}

        local ico, hl = get_web_devicon(filename)
        if hl then
          table.insert(fb_hl, { hl, 0, 3 })
        end
        ico_txt = ico .. '  '

        local file_button_el =
          dashboard.button(shortcut, ico_txt .. label, cmd, nil)
        local fn_start = label:match('.*[/\\]')
        if fn_start ~= nil then
          table.insert(fb_hl, { 'Comment', #ico_txt - 2, #fn_start + #ico_txt })
        end
        file_button_el.opts.hl = fb_hl
        return file_button_el
      end

      local function create_session_button(filename, shortcut, label, cmd)
        local file_button_el =
          dashboard.button(shortcut, '  ' .. label, cmd, nil)
        file_button_el.opts.hl = {}
        return file_button_el
      end

      local function is_file_ignored(filepath)
        local ext = paths.fileext(filepath)
        if
          string.find(filepath, 'COMMIT_EDITMSG')
          or vim.tbl_contains({ 'gitcommit' }, ext)
        then
          return true
        end

        if
          (
            filepath:match(
              'share[\\/]nvim[\\/]' .. 'runtime[\\/]doc[\\/][^%.]+%.txt$'
            )
          )
          or filepath:match('^[\\/]usr[\\/]include[\\/]')
          or filepath:match('^[\\/]usr[\\/]share[\\/]include[\\/]')
        then
          return true
        end

        return false
      end

      local function filtered_unique(items, filter, max_num, case_sensitive)
        local seen = {}
        local results = {}

        for _, item in pairs(items) do
          if max_num ~= nil and max_num >= 0 and #results >= max_num then
            break
          end

          item = item:gsub('[\\/]+', '/'):gsub('%s+$', '')

          if case_sensitive then
            if not seen[item] and filter(item) then
              table.insert(results, item)
            end
            seen[item] = true
          else
            local item_lc = item:lower()
            if not seen[item_lc] and filter(item) then
              table.insert(results, item)
            end
            seen[item_lc] = true
          end
        end

        return results
      end

      local function to_elided(s, max_len)
        local elided = ''

        if max_len > 1 then
          elided = s
          if #s > max_len then
            local first = math.ceil(max_len / 2)
            local second = math.floor(max_len / 2)

            local s1 = s:sub(1, first)
            local s2 = s:sub(math.max(first + 1, #s - second), #s)

            elided = s1 .. '…' .. s2
          end
        end

        return elided
      end

      local function to_elided_filepath(filepath, max_len)
        local elided = filepath

        elided = vim.fn.fnamemodify(filepath, ':.')
        elided = vim.fn.fnamemodify(filepath, ':~')

        if max_len ~= nil and max_len >= 0 and #elided > max_len then
          elided = plenary_path.new(elided):shorten(1, { -2, -1 })

          if #elided > max_len then
            elided = plenary_path.new(elided):shorten(1, { -1 })
          end

          if #elided > max_len then
            elided = elided:gsub('^.*([\\/])(.)', '…%1%2')
          end

          if #elided > max_len then
            local basename = paths.basename(elided)
            local dirname = paths.dirname(elided)
            local extension = paths.fileext(elided) or ''
            local stub = basename:sub(1, #basename - #extension)

            elided = dirname
              .. to_elided(stub, max_len - #dirname - #extension)
              .. extension
          end
        end

        return elided
      end

      local layout = {}

      -- insert banner section
      table.insert(layout, { type = 'padding', val = 2 })
      table.insert(layout, {
        type = 'text',
        val = banner,
        opts = { position = 'center', hl = 'Type' },
      })

      local hookspace = prequire('hookspace')
      if hookspace ~= nil then
        table.insert(layout, { type = 'padding', val = 2 })
        table.insert(layout, {
          type = 'group',
          val = {
            {
              type = 'text',
              val = 'Recent workspaces',
              opts = {
                hl = 'SpecialComment',
                shrink_margin = false,
                position = 'center',
              },
            },
            { type = 'padding', val = 1 },
            {
              type = 'group',
              val = function()
                local entries = hookspace.history()
                local group = {}

                for i = 1, math.min(max_section_items, #entries) do
                  local e = entries[i]
                  local meta = hookspace.info(e.rootdir)
                  local label = (meta and meta.name) or paths.basename(e.rootdir)
                  label = to_elided(label, max_section_width)
                  local cmd = "<cmd>lua require('hookspace').open('"
                    .. e.rootdir:gsub('\\', '\\\\')
                    .. "')<cr>"
                  local button =
                    create_file_button(e.rootdir, tostring(i), label, cmd)
                  table.insert(group, button)
                end

                return {
                  {
                    type = 'group',
                    val = group,
                    opts = {},
                  },
                }
              end,
              opts = { shrink_margin = false },
            },
          },
          opts = { shrink_margin = false },
        })
      end

      -- insert recent files section
      table.insert(layout, { type = 'padding', val = 2 })
      table.insert(layout, {
        type = 'group',
        val = {
          {
            type = 'text',
            val = 'Recent files',
            opts = {
              hl = 'SpecialComment',
              shrink_margin = false,
              position = 'center',
            },
          },
          { type = 'padding', val = 1 },
          {
            type = 'group',
            val = function()
              local ignored_roots = {}

              local cwd = vim.loop.cwd()
              ---@diagnostic disable-next-line: redefined-local
              local hookspace = require('hookspace')
              if hookspace ~= nil then
                local entries = hookspace.history()
                for _, entry in ipairs(entries) do
                  if entry.rootdir then
                    table.insert(ignored_roots, paths.canonical(entry.rootdir, cwd))
                  end
                end
              end

              local filter = function(filepath)
                if
                  vim.fn.filereadable(filepath) ~= 1
                  or is_file_ignored(filepath)
                then
                  return false
                end

                if ignored_roots and #ignored_roots > 0 then
                  local canonical = paths.canonical(filepath, cwd)
                  if vim.fn.has('win32') > 0 then
                    canonical = canonical:lower()
                  end
                  for _, root in ipairs(ignored_roots) do
                    if vim.fn.has('win32') > 0 then
                      root = root:lower()
                    end
                    if #canonical >= #root and canonical:sub(1, #root) == root then
                      return false
                    end
                  end
                end

                return true
              end

              local recent_files = filtered_unique(
                vim.v.oldfiles,
                filter,
                max_section_items,
                vim.fn.has('win32') <= 0
              )
              local group = {}

              for i, filepath in ipairs(recent_files) do
                local label = to_elided_filepath(filepath, max_section_width)
                local shortcut = 'f' .. tostring(i - 1)
                local cmd = '<cmd>e ' .. filepath .. '<cr>'
                local button = create_file_button(filepath, shortcut, label, cmd)
                table.insert(group, button)
              end

              return {
                {
                  type = 'group',
                  val = group,
                  opts = {},
                },
              }
            end,
            opts = { shrink_margin = false },
          },
        },
      })

      table.insert(layout, { type = 'padding', val = 2 })
      table.insert(layout, {
        type = 'group',
        val = function()
          local plugup_btn = dashboard.button(
            'U',
            '󰑐  Update',
            ([[<cmd>lua
          if vim.fn.exists(":PaqSync") == 2 then
            vim.cmd("PaqSync")
          end
          if vim.fn.exists(":PackerSync") == 2 then
            vim.cmd("PackerSync")
          end
          if vim.fn.exists(":Lazy") == 2 then
            vim.cmd("Lazy sync")
          end
          if vim.fn.exists(":Neopm") == 2 then
            vim.cmd("Neopm install")
            vim.cmd("Neopm update")
          end
          if vim.fn.exists(":DepSync") == 2 then
            vim.cmd("DepSync")
          end
          if vim.fn.exists(":PlugUpgrade") == 2 then
            vim.cmd("PlugUpgrade")
          end
          if vim.fn.exists(":PlugUpdate") == 2 then
            vim.cmd("PlugUpdate")
          end

          local treesitter_ok, treesitter = pcall(require, "treesitter")
          if treesitter_ok and treesitter then
            treesitter.update({ with_sync = true })
          end<cr>]]):gsub('\n', ' '),
            nil
          )
          plugup_btn.opts.hl = {}

          local theme_btn = dashboard.button(
            'M',
            '  Theme',
            ([[<cmd>lua
          if vim.fn.exists(":Themery") == 2 then
            vim.cmd("Themery")
          end<cr>]]):gsub('\n', ' '),
            nil
          )
          plugup_btn.opts.hl = {}

          return {
            {
              type = 'group',
              val = { plugup_btn, theme_btn },
              opts = {},
            },
          }
        end,
        opts = { shrink_margin = false },
      })

      return {
        layout = layout,
        opts = { margin = 5, noautocmd = true },
      }
    end
  }
}
