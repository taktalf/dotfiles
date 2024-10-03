vim.cmd("autocmd BufNewFile,BufRead *.tf set filetype=terraform")
local copilot_enabled = os.getenv("COPILOT_ENABLED")

return {
  -- telescope
  {
    'nvim-telescope/telescope.nvim', tag = '0.1.8',
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
      'kyazdani42/nvim-web-devicons',
      'nvim-telescope/telescope-ui-select.nvim',
      "nvim-telescope/telescope-file-browser.nvim"
    },
    keys = {
      {
        "<leader>k",
        function()
          local builtin = require("telescope.builtin")
          builtin.find_files({
            no_ignore = false,
            hidden = true,
          })
        end,
      },
      {
        "<leader>kk",
        function()
          local builtin = require("telescope.builtin")
          builtin.live_grep({})
        end,
      },
      {
        "<leader>e",
        function()
          local telescope = require("telescope")
          local function telescope_buffer_dir()
            return vim.fn.expand("%:p:h")
          end

          telescope.extensions.file_browser.file_browser({
            path = "%:p:h",
            cwd = telescope_buffer_dir(),
            respect_gitignore = false,
            hidden = true,
            grouped = true,
            previewer = false,
            initial_mode = "normal",
            layout_config = { height = 40 },
          })
        end,
        desc = "Open File Browser with the path of the current buffer",
      },
      config = function(_, opts)
        local telescope = require("telescope")
        local fb_actions = require("telescope").extensions.file_browser.actions

        telescope.setup({
          defaults = {
            wrap_results = true,
            layout_strategy = "horizontal",
            layout_config = { prompt_position = "top" },
            sorting_strategy = "ascending",
            winblend = 0,
            mappings = {
              i = {
                ['<C-q>'] = 'close',
              },
              n = {
                ['q'] = 'close',
              },
            },
          },
          pickers = {
            diagnostics = {
              theme = "ivy",
              initial_mode = "normal",
              layout_config = {
                preview_cutoff = 9999,
              },
            },
          },
          extentions = {
            file_browser = {
              theme = "dropdown",
              hijack_netrw = true,
              mappings = {
                ["n"] = {
                  ["N"] = fb_actions.create,
                  ["h"] = fb_actions.goto_parent_dir,
                  ["/"] = function()
                    vim.cmd("startinsert")
                  end,
                  ["<C-u>"] = function(prompt_bufnr)
                    for i = 1, 10 do
                      require("telescope.actions").move_selection_previous(prompt_bufnr)
                    end
                  end,
                  ["<C-d>"] = function(prompt_bufnr)
                    for i = 1, 10 do
                      require("telescope.actions").move_selection_next(prompt_bufnr)
                    end
                  end,
                  ["<PageUp>"] = require("telescope.actions").preview_scrolling_up,
                  ["<PageDown>"] = require("telescope.actions").preview_scrolling_down,
                },
              },
            },
          }
        })

        require("telescope").load_extension("fzf")
        require("telescope").load_extension("file_browser")
      end,
    },
  },
  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate", 
    ensure_installed = {
      "c",
      "lua",
      "vim",
      "vimdoc",
      "query",
      "typescript",
      "javascript",
      "hcl",
      "terraform",
      "json",
      "python",
      "yaml",
      "toml",
    },
    highlight = {
      enable = true,
    },
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    install = function()
      require("nvim-treesitter.install").setup({
        prefer_git = false,
        compilers = { "gcc" }
      })
    end,
    main = 'nvim-treesitter.configs',
    opts = {
      highlight = { enable = true },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    event = "CursorMoved",
  },
  -- lsp関連の設定
  {
    "williamboman/mason.nvim", -- LSPサーバー管理
    cmd = { "Mason", "MasonInstall" },
    event = { "WinNew", "WinLeave", "BufRead" },
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { 'neovim/nvim-lspconfig' },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "terraformls", "pyright" },
      })
      local capabilities = require('cmp_nvim_lsp').default_capabilities()
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
                        -- LuaJIT を使用しているため、Neovimのバージョンに合わせてLuaのバージョンを指定
                        version = 'LuaJIT',
                        -- `vim` のグローバル変数を認識するためのパスを指定
                        path = vim.split(package.path, ';'),
                      },
                      diagnostics = {
                        -- 'vim' のグローバル変数を認識させる
                        globals = { 'vim' },
                      },
                      workspace = {
                        -- NeovimのランタイムファイルをLSPのワークスペースに追加
                        library = vim.api.nvim_get_runtime_file("", true),
                        checkThirdParty = false,  -- 不要な警告を減らすために設定
                      },
                      telemetry = {
                        enable = false,  -- 適宜変更可能
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
    end
  },
  {
    'hashivim/vim-terraform',
    config = function()
      -- 保存時に `terraform fmt` を実行
      vim.g.terraform_fmt_on_save = 1
    end,
    ft = { 'terraform' }  -- terraform ファイルのみに適用
  },
  -- lua関連
  { "L3MON4D3/LuaSnip" },
  { 
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      -- Buffer source for nvim-cmp
      "hrsh7th/cmp-buffer",
      -- Command-line source for nvim-cmp
      "hrsh7th/cmp-cmdline",
      -- Snippet Engine
      "L3MON4D3/LuaSnip",
      -- Snippet completion source
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        sources = {
          { name = 'nvim_lsp' },
          { name = 'buffer' },
          { name = 'path' },
          { name = 'cmdline' },
          { name = 'luasnip' },
        },
      })
    end
  },
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-buffer" },
  { "saadparwaiz1/cmp_luasnip" },
  { "mattn/vim-goimports" },
  {
    "shellRaining/hlchunk.nvim",
    event = { "UIEnter", "BufReadPre", "BufNewFile" },
    config = function()
      require("hlchunk").setup({
        chunk = {
          enable = true,
          use_treesitter = true,
          style = { "#A3BE8C" },
          exclude_filetype = { "help", "dashboard", "markdown" },
        },
        indent = {
          enable = true,
          chars = { "|" },
          style = { "#5E81AC" },
          exclude_filetype = { "help", "dashboard" },
        },
        line_num = {
          enable = true,
          style = "#FFB86C",
        },
        blank = {
          enable = true,
          chars = { "." },
          style = { "#D08770" },
        }
      })
    end
  },
  {
    "is0n/fm-nvim",
    config = function()
      require('fm-nvim').setup{
        -- (Vim) Command used to open files
        edit_cmd = "edit",

        -- See `Q&A` for more info
        on_close = {},
        on_open = {},

        -- UI Options
        ui = {
          -- Default UI (can be "split" or "float")
          default = "float",

          float = {
            -- Floating window border (see ':h nvim_open_win')
            border    = "none",

            -- Highlight group for floating window/border (see ':h winhl')
            float_hl  = "Normal",
            border_hl = "FloatBorder",

            -- Floating Window Transparency (see ':h winblend')
            blend     = 0,

            -- Num from 0 - 1 for measurements
            height    = 0.8,
            width     = 0.8,

            -- X and Y Axis of Window
            x         = 0.5,
            y         = 0.5
          },

          split = {
            -- Direction of split
            direction = "topleft",

            -- Size of split
            size      = 24
          }
        },

        -- Terminal commands used w/ file manager (have to be in your $PATH)
        cmds = {
          lf_cmd      = "lf", -- eg: lf_cmd = "lf -command 'set hidden'"
          fm_cmd      = "fm",
          nnn_cmd     = "nnn",
          fff_cmd     = "fff",
          twf_cmd     = "twf",
          fzf_cmd     = "fzf", -- eg: fzf_cmd = "fzf --preview 'bat --style=numbers --color=always --line-range :500 {}'"
          fzy_cmd     = "find . | fzy",
          xplr_cmd    = "xplr",
          vifm_cmd    = "vifm",
          skim_cmd    = "sk",
          broot_cmd   = "broot",
          gitui_cmd   = "gitui",
          ranger_cmd  = "ranger",
          joshuto_cmd = "joshuto",
          lazygit_cmd = "lazygit",
          neomutt_cmd = "neomutt",
          taskwarrior_cmd = "taskwarrior-tui"
        },

        -- Mappings used with the plugin
        mappings = {
          vert_split = "<C-v>",
          horz_split = "<C-h>",
          tabedit    = "<C-t>",
          edit       = "<C-e>",
          ESC        = "<ESC>"
        },

        -- Path to broot config
        broot_conf = vim.fn.stdpath("data") .. "/site/pack/packer/start/fm-nvim/assets/broot_conf.hjson"
      }
    end
  },
  (copilot_enabled == '1') and {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = {
          enabled = true,
          auto_trigger = true,
          keymap = {
            accept = "<Tab>",
            accept_word = false,
            accept_line = false,
            next = "<M-]>",
            prev = "<M-[>",
            dissmiss = "<M-Enter>",
          },
        },
      })
    end,
  } or nil,
  (copilot_enabled == '1') and {
    "nvim-lua/plenary.nvim",
    event = "InsertEnter",
  } or nil,
  (copilot_enabled == '1') and {
    "CopilotC-nvim/CopilotChat.nvim",
    branch = "canary",
    dependencies = {
      { "zbirenbaum/copilot.lua" },
      { "nvim-lua/plenary.nvim" },
    },
    build = "make tiktoken",
    opts = {},
  },
  { "tpope/vim-fugitive" },
  { "morhetz/gruvbox" },
}

