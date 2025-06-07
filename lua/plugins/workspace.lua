local function read_json(file)
  if vim.fn.filereadable(file) <= 0 then
    return nil
  end

  local handle = io.open(file, "r")
  if not handle then
    return nil
  end

  local data = handle:read("*a")
  handle:close()

  if not data then
    return nil
  end

  local json_ok, json_obj = pcall(vim.fn.json_decode, data)
  if not json_ok then
    return nil
  end

  return json_obj
end


local runterm_config = nil

return {
  {
    'midrare/hookspace.nvim',
    event = "VeryLazy",
    init = function(m)
      local config = require("user.config")

      config.keymaps = config.keymaps or {}
      config.keymaps.n = config.keymaps.n or {}
      config.keymaps.x = config.keymaps.x or {}

      config.keymaps.n['<leader>p'] = {
        label = 'workspaces',
        cmd = '<cmd>Telescope hookspace<cr>',
      }

      config.telescope = config.telescope or {}
      config.telescope.extensions = config.telescope.extensions or {}
      table.insert(config.telescope.extensions, 'hookspace')

      config.lsp = config.lsp or {}
      config.lsp.on_init = config.lsp.on_init or {}
      config.lsp.on_attach = config.lsp.on_attach or {}
      config.lsp.settings = config.lsp.settings or {}

      table.insert(config.lsp.on_init, function(client, init_result)
        local hook = prequire('hookspace.hooks.lspconfig')
        if hook ~= nil then
          client.config.settings = vim.tbl_deep_extend(
            "force",
            client.config.settings or {},
            config.lsp.settings or {},
            hook.lsp_settings(client.name) or {}
          )
          client.notify("workspace/didChangeConfiguration", {
            settings = client.config.settings,
          })
        end

        return true
      end)
    end,
    opts = function(m, opts)
      local cwd = prequire('hookspace.hooks.cwd')
      local env = prequire('hookspace.hooks.environment')
      local trailblazer = prequire('hookspace.hooks.trailblazer')
      local session = prequire('hookspace.hooks.session')
      local lsp = prequire('hookspace.hooks.lspconfig')
      local formatter = prequire('hookspace.hooks.formatter')

      local function runterm_on_open(workspace)
        local runterm = prequire('runterm')
        if runterm ~= nil then
          runterm_config = runterm.config()
          local cfg = read_json(workspace.localdir() .. '/runterm.json') or {}
          runterm.setup(vim.tbl_deep_extend('force', runterm.config(), {
            open_with_profile = cfg.runterm_profile,
            open_with_cmd = cfg.runterm_cmd,
          }))
        end
      end

      ---@diagnostic disable-next-line: unused-local
      local function runterm_on_close(workspace)
        local runterm = prequire('runterm')
        if runterm ~= nil then
          runterm.setup(runterm_config or {})
          runterm_config = nil
        end
      end

      opts.autoload = true
      opts.on_open = opts.on_open or {}
      opts.on_close = opts.on_close or {}

      table.insert(opts.on_open, env and env.on_open)
      table.insert(opts.on_open, runterm_on_open)
      table.insert(opts.on_open, lsp and lsp.on_open)
      -- table.insert(opts.on_open, trailblazer and trailblazer.on_open)
      table.insert(opts.on_open, formatter and formatter.on_open)
      table.insert(opts.on_open, session and session.on_open)
      table.insert(opts.on_open, cwd and cwd.on_open)

      -- table.insert(opts.on_close, trailblazer and trailblazer.on_close)
      table.insert(opts.on_close, formatter and formatter.on_close)
      table.insert(opts.on_close, session and session.on_close)
      table.insert(opts.on_close, cwd and cwd.on_close)
      table.insert(opts.on_close, lsp and lsp.on_close)
      table.insert(opts.on_close, runterm_on_close)
      table.insert(opts.on_close, env and env.on_close)
    end,
  }
}
