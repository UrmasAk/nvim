return {
  {
    "Saghen/blink.cmp",
    opts = {
      enabled = function()
        -- Disable blink completely in DAP REPL, prompt buffers, and watch inputs
        return vim.bo.filetype ~= "dap-repl"
          and vim.bo.buftype ~= "prompt"
          and not vim.tbl_contains({ "dap-ui_watches", "dap-ui_scopes" }, vim.bo.filetype)
      end,
    },
  },
}
