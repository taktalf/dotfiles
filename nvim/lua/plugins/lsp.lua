-- LSP関連のプラグイン

return {
  -- mason.nvim: LSPサーバーの管理とインストールを容易にするプラグイン
  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall" },
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
      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      capabilities.textDocument.semanticTokens = nil
      require("mason-lspconfig").setup_handlers {
        function (server_name)
          require("lspconfig")[server_name].setup {
            on_attach = function(client, bufnr)
              -- LSPサーバーのフォーマット機能を無効にするには下の行をコメントアウト
              -- client.resolved_capabilities.document_formatting = false

              local set = vim.keymap.set
              set("n", "C-[", "<cmd>lua vim.lsp.buf.declaration()<CR>")
              set("n", "C-]", "<cmd>lua vim.lsp.buf.definition()<CR>")
              set("n", "S-K", "<cmd>lua vim.lsp.buf.hover()<CR>")
              set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")
              set("n", "gf", "<cmd>lua vim.lsp.buf.formatting()<CR>")
              set("n", "gt", "<cmd>lua vim.lsp.buf.type_definition()<CR>")
              set("n", "gn", "<cmd>lua vim.lsp.buf.rename()<CR>")
              set("n", "ga", "<cmd>lua vim.lsp.buf.code_action()<CR>")
              set("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>")
              set("n", "ge", "<cmd>lua vim.lsp.diagnostic.open_float()<CR>")
              set("n", "g[", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>")
              set("n", "g]", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>")
              set("n", "<space>q", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>")

              -- 特定のLSPサーバーに対して特別な設定を行う
              if server_name == "lua_ls" then
                require('lspconfig').lua_ls.setup {
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
                  capabilities = capabilities,
                }
              end
            end,
            capabilities = capabilities,
          }
        end,
      }
    end,
  },
}
