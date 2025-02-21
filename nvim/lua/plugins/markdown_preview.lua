-- Markdownプレビュー用のプラグイン

-- iamcco/markdown-preview.nvim: Markdownファイルのプレビューを提供するプラグイン
{
  "iamcco/markdown-preview.nvim",
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  build = "cd app && yarn install",
  init = function()
    vim.g.mkdp_filetypes = { "markdown" }
  end,
  ft = { "markdown" },
},