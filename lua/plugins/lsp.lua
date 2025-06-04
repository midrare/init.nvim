local config = require("user.config")


config.lsp = config.lsp or {}
config.lsp.ensure_installed = config.lsp.ensure_installed or {}
config.lsp.on_attach = config.lsp.on_attach or {}
config.lsp.on_init = config.lsp.on_init or {}
config.lsp.settings = config.lsp.settings or {}

config.lsp.settings = vim.tbl_deep_extend("keep", config.lsp.settings, {
  Lua = {
    workspace = {
      checkThirdParty = false
    }
  },
  json = {
    -- Find more schemas here: https://www.schemastore.org/json/
    schemas = {
      {
        description = 'TypeScript compiler configuration file',
        fileMatch = {
          'tsconfig.json',
          'tsconfig.*.json',
        },
        url = 'https://json.schemastore.org/tsconfig.json',
      },
      {
        description = 'Lerna config',
        fileMatch = { 'lerna.json' },
        url = 'https://json.schemastore.org/lerna.json',
      },
      {
        description = 'Babel configuration',
        fileMatch = {
          '.babelrc.json',
          '.babelrc',
          'babel.config.json',
        },
        url = 'https://json.schemastore.org/babelrc.json',
      },
      {
        description = 'ESLint config',
        fileMatch = {
          '.eslintrc.json',
          '.eslintrc',
        },
        url = 'https://json.schemastore.org/eslintrc.json',
      },
      {
        description = 'Bucklescript config',
        fileMatch = { 'bsconfig.json' },
        url = 'https://raw.githubusercontent.com/rescript-lang/rescript-compiler/8.2.0/docs/docson/build-schema.json',
      },
      {
        description = 'Prettier config',
        fileMatch = {
          '.prettierrc',
          '.prettierrc.json',
          'prettier.config.json',
        },
        url = 'https://json.schemastore.org/prettierrc',
      },
      {
        description = 'Vercel Now config',
        fileMatch = { 'now.json' },
        url = 'https://json.schemastore.org/now',
      },
      {
        description = 'Stylelint config',
        fileMatch = {
          '.stylelintrc',
          '.stylelintrc.json',
          'stylelint.config.json',
        },
        url = 'https://json.schemastore.org/stylelintrc',
      },
      {
        description = 'A JSON schema for the ASP.NET LaunchSettings.json files',
        fileMatch = { 'launchsettings.json' },
        url = 'https://json.schemastore.org/launchsettings.json',
      },
      {
        description = 'Schema for CMake Presets',
        fileMatch = {
          'CMakePresets.json',
          'CMakeUserPresets.json',
        },
        url = 'https://raw.githubusercontent.com/Kitware/CMake/master/Help/manual/presets/schema.json',
      },
      {
        description = 'Configuration file as an alternative for configuring your repository in the settings page.',
        fileMatch = {
          '.codeclimate.json',
        },
        url = 'https://json.schemastore.org/codeclimate.json',
      },
      {
        description = 'LLVM compilation database',
        fileMatch = {
          'compile_commands.json',
        },
        url = 'https://json.schemastore.org/compile-commands.json',
      },
      {
        description = 'Config file for Command Task Runner',
        fileMatch = {
          'commands.json',
        },
        url = 'https://json.schemastore.org/commands.json',
      },
      {
        description = 'AWS CloudFormation provides a common language for you to describe and provision all the infrastructure resources in your cloud environment.',
        fileMatch = {
          '*.cf.json',
          'cloudformation.json',
        },
        url = 'https://raw.githubusercontent.com/awslabs/goformation/v5.2.9/schema/cloudformation.schema.json',
      },
      {
        description = 'The AWS Serverless Application Model (AWS SAM, previously known as Project Flourish) extends AWS CloudFormation to provide a simplified way of defining the Amazon API Gateway APIs, AWS Lambda functions, and Amazon DynamoDB tables needed by your serverless application.',
        fileMatch = {
          'serverless.template',
          '*.sam.json',
          'sam.json',
        },
        url = 'https://raw.githubusercontent.com/awslabs/goformation/v5.2.9/schema/sam.schema.json',
      },
      {
        description = 'Json schema for properties json file for a GitHub Workflow template',
        fileMatch = {
          '.github/workflow-templates/**.properties.json',
        },
        url = 'https://json.schemastore.org/github-workflow-template-properties.json',
      },
      {
        description = 'golangci-lint configuration file',
        fileMatch = {
          '.golangci.toml',
          '.golangci.json',
        },
        url = 'https://json.schemastore.org/golangci-lint.json',
      },
      {
        description = 'JSON schema for the JSON Feed format',
        fileMatch = {
          'feed.json',
        },
        url = 'https://json.schemastore.org/feed.json',
        versions = {
          ['1'] = 'https://json.schemastore.org/feed-1.json',
          ['1.1'] = 'https://json.schemastore.org/feed.json',
        },
      },
      {
        description = 'Packer template JSON configuration',
        fileMatch = {
          'packer.json',
        },
        url = 'https://json.schemastore.org/packer.json',
      },
      {
        description = 'NPM configuration file',
        fileMatch = {
          'package.json',
        },
        url = 'https://json.schemastore.org/package.json',
      },
      {
        description = 'JSON schema for Visual Studio component configuration files',
        fileMatch = {
          '*.vsconfig',
        },
        url = 'https://json.schemastore.org/vsconfig.json',
      },
      {
        description = 'Resume json',
        fileMatch = { 'resume.json' },
        url = 'https://raw.githubusercontent.com/jsonresume/resume-schema/v1.0.0/schema.json',
      },
    },
  },
})


-- local jsonls_opts = {
--   setup = {
--     commands = {
--       Format = {
--         function()
--           vim.lsp.buf.range_formatting({}, { 0, 0 }, { vim.fn.line('$'), 0 })
--         end,
--       },
--     },
--   },
-- }


vim.diagnostic.config({
  severity_sort = true,
  float = {
    focusable = false,
    source = 'always',
    style = 'minimal',
    header = '',
    prefix = '',
  },
})

vim.fn.sign_define('DiagnosticSignError', {
  texthl = 'DiagnosticSignError', text = '' })
vim.fn.sign_define('DiagnosticSignWarn', {
  texthl = 'DiagnosticSignWarn', text = '' })
vim.fn.sign_define('DiagnosticSignHint', {
  texthl = 'DiagnosticSignHint', text = '' })
vim.fn.sign_define('DiagnosticSignInfo', {
  texthl = 'DiagnosticSignInfo', text = '' })


local function fnseq(fns)
  local fns_ = vim.iter({fns}):flatten():totable()
  return function(client, initialize_result)
    for _, fn in ipairs(fns_) do
      if type(fn) == "string" then
        vim.cmd('silent! ' .. vim.fn.excape(fn, " "))
      elseif type(fn) == "function" then
        fn(client, initialize_result)
      end
    end
  end
end


return {
  {
    'williamboman/mason.nvim',
    -- lazy loading is not recommended for mason.nvim
    dependencies = {
      'williamboman/mason-lspconfig.nvim',
      'neovim/nvim-lspconfig',
    },
    config = function(m, opts)
      local config = require("user.config")
      config.lsp = config.lsp or {}
      config.lsp.on_init = config.lsp.on_init or {}
      config.lsp.on_attach = config.lsp.on_attach or {}
      config.lsp.settings = config.lsp.settings or {}

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local cmp_ok, cmp = pcall(require, 'cmp_nvim_lsp')
      if cmp_ok and cmp then
        capabilities = cmp.default_capabilities()
      end

      vim.lsp.config("*", {
        capabilities = capabilities,
        on_init = fnseq(config.lsp.on_init),
        on_attach = fnseq(config.lsp.on_attach),
        settings = config.lsp.settings or {},
      })

      require("mason").setup(opts)
      require('mason-lspconfig').setup({
        ensure_installed = config.lsp.ensure_installed,
        automatic_enable = true,
      })
    end,
  },
  {
    'onsails/lspkind.nvim',
    event = "VeryLazy",
    config = function(m, opts)
      require("lspkind").init(opts)
    end,
  },
  {
    'RishabhRD/nvim-lsputils',
    event = "VeryLazy",
    dependencies = { 'RishabhRD/popfix' },
    config = function(m, opts)
      vim.lsp.handlers['textDocument/codeAction'] =
        require('lsputil.codeAction').code_action_handler
      vim.lsp.handlers['textDocument/references'] =
        require('lsputil.locations').references_handler
      vim.lsp.handlers['textDocument/definition'] =
        require('lsputil.locations').definition_handler
      vim.lsp.handlers['textDocument/declaration'] =
        require('lsputil.locations').declaration_handler
      vim.lsp.handlers['textDocument/typeDefinition'] =
        require('lsputil.locations').typeDefinition_handler
      vim.lsp.handlers['textDocument/implementation'] =
        require('lsputil.locations').implementation_handler
      vim.lsp.handlers['textDocument/documentSymbol'] =
        require('lsputil.symbols').document_handler
      vim.lsp.handlers['workspace/symbol'] =
        require('lsputil.symbols').workspace_handler
      -- vim.cmd("autocmd CursorHold * lua vim.diagnostic.open_float()")
      -- vim.cmd("autocmd CursorHoldI * silent! lua vim.lsp.buf.signature_help()")
    end
  },
  {
    'nvimtools/none-ls.nvim',
    event = "VeryLazy",
    dependencies = 'nvim-lua/plenary.nvim',
    opts = function(m, opts)
      local null_ls = require("null-ls")
      return {
        sources = {
          -- null_ls.builtins.code_actions.refactoring,
          -- null_ls.builtins.code_actions.shellcheck,
          -- null_ls.builtins.code_actions.xo,
          --
          -- null_ls.builtins.diagnostics.checkmake,
          -- null_ls.builtins.diagnostics.chktex,
          -- null_ls.builtins.diagnostics.clj_kondo,
          -- null_ls.builtins.diagnostics.codespell,

          -- C, C++
          -- choco install cppcheck
          null_ls.builtins.diagnostics.cppcheck,

          -- null_ls.builtins.diagnostics.eslint,
          -- null_ls.builtins.diagnostics.flake8,
          -- null_ls.builtins.diagnostics.fish,
          -- null_ls.builtins.diagnostics.gccdiag,
          -- null_ls.builtins.diagnostics.gdlint,
          -- null_ls.builtins.diagnostics.gitlint,
          -- null_ls.builtins.diagnostics.golangci_lint,
          -- null_ls.builtins.diagnostics.hadolint,
          -- null_ls.builtins.diagnostics.jsonlint,
          -- null_ls.builtins.diagnostics.ktlint,
          -- null_ls.builtins.diagnostics.markdownlint,
          -- null_ls.builtins.diagnostics.mypy,
          -- null_ls.builtins.diagnostics.php,
          -- null_ls.builtins.diagnostics.phpcs,
          -- null_ls.builtins.diagnostics.phpmd,
          -- null_ls.builtins.diagnostics.pydocstyle,
          -- null_ls.builtins.diagnostics.pylama,
          -- null_ls.builtins.diagnostics.pylint,
          -- null_ls.builtins.diagnostics.revive,
          -- null_ls.builtins.diagnostics.rubocop,

          -- obviates luacheck
          -- obviated by folke/luadev
          -- null_ls.builtins.diagnostics.selene,

          -- null_ls.builtins.diagnostics.semgrep,
          -- null_ls.builtins.diagnostics.shellcheck,
          -- null_ls.builtins.diagnostics.standardjs,
          -- null_ls.builtins.diagnostics.standardrb,
          -- null_ls.builtins.diagnostics.staticcheck,
          -- null_ls.builtins.diagnostics.stylelint,
          -- null_ls.builtins.diagnostics.stylint,
          -- null_ls.builtins.diagnostics.teal,
          -- null_ls.builtins.diagnostics.tidy,
          -- null_ls.builtins.diagnostics.tsc,
          -- null_ls.builtins.diagnostics.vint,
          -- null_ls.builtins.diagnostics.vulture,
          -- null_ls.builtins.diagnostics.xo,
          -- null_ls.builtins.diagnostics.yamllint,
          -- null_ls.builtins.diagnostics.zsh,
          -- null_ls.builtins.formatting.asmfmt,

          -- C, C++, C++/CLI, Objective-C, C#, Java
          -- choco install astyle
          null_ls.builtins.formatting.astyle,

          -- null_ls.builtins.formatting.autopep8,
          -- null_ls.builtins.formatting.bibclean,
          -- null_ls.builtins.formatting.black,
          -- null_ls.builtins.formatting.brittany,
          -- null_ls.builtins.formatting.clang_format,
          -- null_ls.builtins.formatting.cljstyle,

          -- CMake
          -- pip install cmakelang
          null_ls.builtins.formatting.cmake_format,

          -- null_ls.builtins.formatting.codespell,
          -- null_ls.builtins.formatting.crystal_format,
          -- null_ls.builtins.formatting.deno_fmt,
          -- null_ls.builtins.formatting.dfmt,
          -- null_ls.builtins.formatting.elm_format,
          -- null_ls.builtins.formatting.erb_lint,
          -- null_ls.builtins.formatting.erlfmt,
          -- null_ls.builtins.formatting.eslint,
          -- null_ls.builtins.formatting.fish_indent,
          -- null_ls.builtins.formatting.fixjson,
          -- null_ls.builtins.formatting.fnlfmt,
          -- null_ls.builtins.formatting.format_r,
          -- null_ls.builtins.formatting.fourmolu,
          -- null_ls.builtins.formatting.fprettify,
          -- null_ls.builtins.formatting.gdformat,
          -- null_ls.builtins.formatting.gofmt,
          -- null_ls.builtins.formatting.goimports,
          -- null_ls.builtins.formatting.google_java_format,
          -- null_ls.builtins.formatting.isort,
          -- null_ls.builtins.formatting.joker,
          -- null_ls.builtins.formatting.jq,
          -- null_ls.builtins.formatting.ktlint,
          -- null_ls.builtins.formatting.latexindent,
          -- null_ls.builtins.formatting.lua_format,
          -- null_ls.builtins.formatting.markdownlint,
          -- null_ls.builtins.formatting.nimpretty,
          -- null_ls.builtins.formatting.perltidy,
          -- null_ls.builtins.formatting.phpcbf,
          -- null_ls.builtins.formatting.phpcsfixer,
          -- null_ls.builtins.formatting.prettier,
          -- null_ls.builtins.formatting.raco_fmt,
          -- null_ls.builtins.formatting.remark,
          -- null_ls.builtins.formatting.reorder_python_imports,
          -- null_ls.builtins.formatting.rome,
          -- null_ls.builtins.formatting.rubocop,
          -- null_ls.builtins.formatting.rufo,
          -- null_ls.builtins.formatting.rustfmt,
          -- null_ls.builtins.formatting.scalafmt,
          -- null_ls.builtins.formatting.shellharden,
          -- null_ls.builtins.formatting.shfmt,
          -- null_ls.builtins.formatting.sqlformat,
          -- null_ls.builtins.formatting.standardjs,
          -- null_ls.builtins.formatting.stylelint,
          -- null_ls.builtins.formatting.styler,
          -- null_ls.builtins.formatting.stylua,
          -- null_ls.builtins.formatting.swiftformat,
          -- null_ls.builtins.formatting.taplo,
          -- null_ls.builtins.formatting.tidy,
          -- null_ls.builtins.formatting.uncrustify,
          -- null_ls.builtins.formatting.xmllint,
          -- null_ls.builtins.formatting.yapf,
          -- null_ls.builtins.formatting.zigfmt,

          null_ls.builtins.hover.dictionary,
        },
      }
    end
  }
}
