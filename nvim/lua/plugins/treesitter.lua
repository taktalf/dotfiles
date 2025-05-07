-- シンタックスハイライトおよびコード解析用のプラグイン

-- nvim-treesitter: 高性能なシンタックスハイライトとコードパーシングを提供するプラグイン
return {
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
      "ruby",
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

  -- nvim-treesitter-textobjects: テキストオブジェクトの拡張を提供するプラグイン
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    event = "CursorMoved",
  },
}
