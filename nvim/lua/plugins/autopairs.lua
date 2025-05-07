-- オートペアリング関連のプラグイン

-- nvim-autopairs: 自動でペアを補完するプラグイン
return {
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup{}
    end,
  },
}