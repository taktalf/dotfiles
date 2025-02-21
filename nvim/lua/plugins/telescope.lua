-- ファイル探索用のプラグイン

-- telescope.nvim: 高機能なファイル探索プラグイン
return {
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
        desc = "ファイルを検索"
      },
      {
        "<leader>kk",
        function()
          local builtin = require("telescope.builtin")
          builtin.live_grep({})
        end,
        desc = "テキストを検索"
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
        desc = "カレントバッファのパスでファイルブラウザを開く"
      },
      {
        "<leader>gc",
        function()
          local builtin = require("telescope.builtin")
          builtin.git_commits({})
        end,
        desc = "Gitコミットを表示"
      },
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
        extensions = {
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
}