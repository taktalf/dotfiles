-- Terraform関連のプラグイン

-- vim-terraform: Terraformファイルのシンタックスハイライトと補完を提供するプラグイン
{
  "hashivim/vim-terraform",
  config = function()
    -- 保存時に `terraform fmt` を実行
    vim.g.terraform_fmt_on_save = 1
  end,
  ft = { "terraform" },  -- terraform ファイルのみに適用
},