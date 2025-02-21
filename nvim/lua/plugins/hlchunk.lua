-- シンタックスハイライトおよびインデントハイライト改善用のプラグイン

-- shellRaining/hlchunk.nvim: シンタックスハイライトやインデントハイライトを改善するプラグイン
return {
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
    end,
  },
}
