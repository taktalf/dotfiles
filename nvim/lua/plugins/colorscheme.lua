-- カラースキーム関連のプラグイン

-- sonokai: 美しいカラースキームプラグイン
return {
  {
    "sainnhe/sonokai",
    config = function()
      vim.cmd("colorscheme sonokai")
      vim.api.nvim_set_hl(0, "Normal", { ctermbg = "none", bg = "none" })
    end,
  },
}