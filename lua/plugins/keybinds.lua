local modulename, _ = ...

local cmds = {}
local hydra_cmds = {}

---@class keymap
---@field cmd? string|fun() command to run
---@field label? string display name in which-key and hydra
---@field silent? boolean defaults to true
---@field repeatable? boolean defaults to false

local function parse_keypresses(input)
  local components = {}
  while true do
    local m = input:match('^<[^<>]->')
      or input:match('^\\.')
      or input:match('^.')
    if not m or #m <= 0 then
      break
    end
    table.insert(components, m)
    input = input:sub(#m + 1)
  end
  return components
end

---@param mode string
---@param input string
---@param map keymap
local function enqueue_keymap(mode, input, map)
  if map.cmd == 0 then
    return
  end

  local prefix = input
  local key = 0

  if map.cmd then
    local keypresses = parse_keypresses(input)
    key = keypresses[#keypresses]
    table.remove(keypresses, #keypresses)
    prefix = #keypresses > 0 and table.concat(keypresses) or ''
  end

  cmds[mode] = cmds[mode] or {}
  cmds[mode][prefix] = cmds[mode][prefix] or {}

  if cmds[mode][prefix][key] then
    vim.notify(
      'Duplicate keymap '
        .. 'mode:'
        .. mode
        .. ' '
        .. 'input:'
        .. input
        .. ' '
        .. 'mapping:'
        .. vim.inspect(map),
      -- split to hide from to-do list plugin
      vim.log.levels['WA' .. 'RN'],
      { title = modulename }
    )
  else
    if not map.repeatable then
      cmds[mode][prefix][key] = vim.tbl_extend("force", {}, map)
    else
      cmds[mode][prefix][key] = vim.tbl_extend("force", {}, map)
      cmds[mode][prefix][key].cmd = nil

      hydra_cmds[mode] = hydra_cmds[mode] or {}
      hydra_cmds[mode][prefix] = hydra_cmds[mode][prefix] or {}
      hydra_cmds[mode][prefix][key] = vim.tbl_extend("force", {}, map)
    end
  end
end

local function foreach_keymap(m, f)
  for mode, prefixes in pairs(m) do
    for prefix, keymaps in pairs(prefixes) do
      for key, mapping in pairs(keymaps) do
        f(mode, prefix, key, mapping)
      end
    end
  end
end


local _initialized_cmds = false
local function enqueue_keymaps()
  if _initialized_cmds then
    return
  end

  local config = require("user.config")
  for mode, inputs in pairs((config or {}).keymaps or {}) do
    for input, map in pairs(inputs) do
      enqueue_keymap(mode, input, map)
    end
  end

  _initialized_cmds = true
end


return {
  {
    'folke/which-key.nvim',
    event = "VeryLazy",
    opts = {
      plugins = {
        registers = false,
        marks = false,
        spelling = { enabled = false },
        presets = {
          operators = false,
          motions = false,
          text_objects = false,
          windows = false,
          nav = false,
          z = true,
          g = true,
        },
      },
      window = { border = 'single' },
      ignore_missing = true,
      key_labels = { ['<lt>'] = '<', ['>'] = '>' },
      icons = { separator = '→' },
    },
    config = function(m, opts)
      enqueue_keymaps()

      local whichkey = require("which-key")
      whichkey.setup(opts)
      foreach_keymap(cmds, function(mode, prefix, key, map)
        if key == 0 and whichkey then
          whichkey.register({ [prefix] = { name = map.label } }, {
            mode = mode,
            silent = map.silent ~= false,
            nowait = map.nowait ~= false,
            noremap = map.noremap ~= false,
            expr = map.expr == true,
          })
        elseif key ~= 0 and whichkey then
          local bind = {}
          if not map.cmd and not map.hidden then
            bind = { map.label }
          elseif map.cmd and map.hidden then
            bind = { map.cmd, "which_key_ignore" }
          elseif map.cmd and not map.hidden then
            bind = { map.cmd, map.label }
          elseif not map.cmd and map.hidden then
            bind = {}
          end

          if bind then
            whichkey.register(
              { [key] = bind },
              {
                mode = mode,
                prefix = prefix,
                silent = map.silent ~= false,
                nowait = map.nowait ~= false,
                noremap = map.noremap ~= false,
                expr = map.expr == true,
              }
            )
          end
        elseif key ~= 0 then
          local opts = vim.deepcopy(map)
          opts.silent = map.silent ~= false
          opts.nowait = map.nowait ~= false
          opts.noremap = map.noremap ~= false
          opts.expr = map.expr == true
          vim.keymap.set(mode, prefix .. key, map.cmd, opts)
        end
      end)
    end
  },
  {
    'anuvyklack/hydra.nvim',
    event = "VeryLazy",
    config = function(m, opts)
      enqueue_keymaps()

      local hydra = require("hydra")
      local hydras = {}

      foreach_keymap(hydra_cmds, function(mode, prefix, key, map)
        hydras[mode] = hydras[mode] or {}
        hydras[mode][prefix] = hydras[mode][prefix]
          or vim.deepcopy(((hydra_cmds[mode] or {})[prefix] or {})[0] or {})

        hydras[mode][prefix].name = hydras[mode][prefix].name
          or hydras[mode][prefix].label
          or nil
        hydras[mode][prefix].mode = hydras[mode][prefix].mode or mode
        hydras[mode][prefix].body = hydras[mode][prefix].body or prefix
        hydras[mode][prefix].heads = hydras[mode][prefix].heads or {}

        if key ~= 0 then
          local opts = vim.deepcopy(map)
          opts.desc = map.label
          opts.noremap = map.noremap ~= false
          opts.nowait = map.nowait ~= false
          opts.silent = map.silent ~= false
          table.insert(hydras[mode][prefix].heads, { key, map.cmd, opts })
        end
      end)

      for _, prefixes in pairs(hydras) do
        for _, mappings in pairs(prefixes) do
          hydra(mappings)
        end
      end
    end
  }
}
