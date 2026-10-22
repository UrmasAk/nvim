return {
  "A7lavinraj/assistant.nvim",
  lazy = false,
  keys = {
    { "<leader>a", "<cmd>Assistant<cr>", desc = "Assistant.nvim" },
  },
  opts = {
    commands = {
      cpp = {
        template = vim.fn.expand("~/.config/nvim/templates/template.cpp"),
      },
    },
  },
}
