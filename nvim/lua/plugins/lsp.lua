-- LSP関連のプラグイン

return {
  -- mason.nvim: LSPサーバーの管理とインストールを容易にするプラグイン
  {
    "williamboman/mason.nvim",
    event = { "WinNew", "WinLeave", "BufRead" },
    config = function()
      require("mason").setup()
    end,
  },

  -- mason-lspconfig.nvim: masonとnvim-lspconfigの連携を提供するプラグイン
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { 'neovim/nvim-lspconfig' },
    config = function()
      -- 共通のon_attach関数を定義
      local on_attach = function(client, bufnr)
        local opts = { noremap = true, silent = true, buffer = bufnr }
        vim.keymap.set("n", "<C-[>", vim.lsp.buf.declaration, opts)
        vim.keymap.set("n", "<C-]>", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "<S-K>", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
        vim.keymap.set("n", "gf", function() vim.lsp.buf.format({ async = true }) end, opts)
        vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, opts)
        vim.keymap.set("n", "gn", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "ga", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "ge", vim.diagnostic.open_float, opts)
        vim.keymap.set("n", "g[", vim.diagnostic.goto_prev, opts)
        vim.keymap.set("n", "g]", vim.diagnostic.goto_next, opts)
        vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, opts)
      end

      -- 診断表示を有効化する設定
      vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
      })

      -- LSPサーバーの設定をvim.lsp.configで定義
      vim.lsp.config('*', {
        on_attach = on_attach,
        flags = {
          debounce_text_changes = 150,
        },
        root_markers = { '.git' },
      })

      -- lua_lsの特別な設定
      vim.lsp.config('lua_ls', {
        settings = {
          Lua = {
            runtime = {
              version = 'LuaJIT',
              path = vim.split(package.path, ';'),
            },
            diagnostics = {
              globals = { 'vim' },
            },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
            telemetry = {
              enable = false,
            },
          },
        },
      })

      -- goplsの特別な設定
      vim.lsp.config('gopls', {
        settings = {
          gopls = {
            gofumpt = true,
            analyses = {
              unusedparams = true,
              unreachable = true,
              nilness = true,
              shadow = true,
            },
            staticcheck = true,
            usePlaceholders = true,
            completeUnimported = true,
            diagnosticsDelay = "300ms",
            importShortcut = "Both",
            goimports = true,
          },
        },
        on_attach = function(client, bufnr)
          on_attach(client, bufnr)
          if client.server_capabilities.documentFormattingProvider then
            vim.api.nvim_create_autocmd("BufWritePre", {
              group = vim.api.nvim_create_augroup("GoFormat", { clear = true }),
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format({ async = false })
              end,
            })
          end
        end,
      })

      -- mason-lspconfigでインストール済みサーバーを有効化
      require("mason-lspconfig").setup_handlers {
        function(server_name)
          vim.lsp.enable(server_name)
        end,
      }
    end,
  },
}
