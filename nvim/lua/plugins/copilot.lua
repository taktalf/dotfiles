local copilot_enabled = os.getenv("COPILOT_ENABLED")
local plugins = {}

if copilot_enabled == '1' then
  table.insert(plugins, {
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
        copilot_node_command = 'node'
      })
    end,
  })
end

if copilot_enabled == '1' then
  table.insert(plugins, {
    "CopilotC-nvim/CopilotChat.nvim",
    branch = "main",
    dependencies = {
      { "zbirenbaum/copilot.lua" },
      { "nvim-lua/plenary.nvim" },
    },
    build = "make tiktoken",
    opts = {},
  })
end

return plugins
