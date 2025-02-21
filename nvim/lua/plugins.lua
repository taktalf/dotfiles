-- プラグイン設定をカテゴリ別に分割しています

return {
  require("plugins.lsp"),
  require("plugins.telescope"),
  require("plugins.treesitter"),
  require("plugins.cmp"),
  require("plugins.autopairs"),
  require("plugins.git"),
  require("plugins.terraform"),
  require("plugins.snippets"),
  require("plugins.hlchunk"),
  require("plugins.markdown_preview"),
}
