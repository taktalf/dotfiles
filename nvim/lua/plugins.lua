-- プラグイン設定をカテゴリ別に分割しています

local unpack = table.unpack or unpack -- Lua 5.1 互換のためローカルに unpack を定義

return {
  unpack(require("plugins.lsp")),
  unpack(require("plugins.telescope")),
  unpack(require("plugins.treesitter")),
  unpack(require("plugins.cmp")),
  unpack(require("plugins.autopairs")),
  unpack(require("plugins.git")),
  unpack(require("plugins.terraform")),
  unpack(require("plugins.snippets")),
  unpack(require("plugins.hlchunk")),
  unpack(require("plugins.markdown_preview")),
  unpack(require("plugins.colorscheme")),
}
