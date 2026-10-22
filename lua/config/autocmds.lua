-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
vim.filetype.add({
  filename = {
    ["CMakeLists.txt"] = "cmake",
  },
  pattern = {
    ["%.cmake"] = "cmake",
  },
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "rust",
  callback = function(event)
    vim.keymap.set("n", "<leader>rr", function()
      -- 1. Save if modified
      if vim.bo.modified then
        vim.cmd("write")
      end

      -- 2. Open the terminal using your default <c-/> key combination
      local ctrl_slash = vim.api.nvim_replace_termcodes("<c-/>", true, false, true)
      vim.api.nvim_feedkeys(ctrl_slash, "m", false)

      -- 3. Feed "cargo run" + Enter into the active terminal buffer
      vim.schedule(function()
        vim.api.nvim_feedkeys("env RUST_BACKTRACE=1 cargo run\n", "t", false)
      end)
    end, { buffer = event.buf, desc = "Save, Toggle Terminal, and Run Cargo" })
  end,
})
