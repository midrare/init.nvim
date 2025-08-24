local config = require('user.config')
config.telescope = config.telescope or {}
config.telescope.extensions = config.telescope.extensions or {}

return {
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    init = function()
      vim.api.nvim_create_user_command(
        "NotificationHistory",
        function()
          local notifier = prequire("snacks.notifier")
          if notifier ~= nil then
            notifier.show_history()
          end
        end,
        {}
      )
    end,
    opts = {
      notifier = { style = 'compact' },
      input = {},
    },
  },
}
