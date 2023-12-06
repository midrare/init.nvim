local config = require("user.config")
config.ignored_filetypes = config.ignored_filetypes or {}

config.keymaps = config.keymaps or {}
config.keymaps.n = config.keymaps.n or {}

config.keymaps.n['[b'] = {
  cmd = function()
    require("cokeline.mappings").by_step("focus", -1)
  end,
  label = 'previous buffer',
  repeatable = true,
}

config.keymaps.n[']b'] = {
  cmd = function()
    require("cokeline.mappings").by_step("focus", 1)
  end,
  label = 'next buffer',
  repeatable = true,
}

config.keymaps.n['[B'] = {
  cmd = function()
    require("cokeline.mappings").by_step("switch", -1)
  end,
  label = 'prev buffer pos',
  repeatable = true,
}

config.keymaps.n[']B'] = {
  cmd = function()
    require("cokeline.mappings").by_step("switch", 1)
  end,
  label = 'next buffer pos',
  repeatable = true,
}


return {
  {
    "willothy/nvim-cokeline",
    event = 'VimEnter',
    dependencies = {
      "nvim-lua/plenary.nvim",
      "kyazdani42/nvim-web-devicons",
      "stevearc/resession.nvim",
    },
    config = true,
  },
  {
    "tiagovla/scope.nvim",
    init = function(m)
      local config = require("user.config")
      config.telescope = config.telescope or {}
      config.telescope.extensions = config.telescope.extensions or {}
      table.insert(config.telescope.extensions, 'scope')
    end,
    config = true,
  }
}
