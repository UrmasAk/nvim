-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
local map = vim.keymap.set

-- Safe CMake Shortcuts (Using <leader>m for "Make/CMake")
map("n", "<leader>mg", "<cmd>CMakeGenerate<cr>", { desc = "CMake Generate" })
map("n", "<leader>mb", "<cmd>CMakeBuild<cr>", { desc = "CMake Build" })
map("n", "<leader>mr", "<cmd>CMakeRun<cr>", { desc = "CMake Run" })
map("n", "<leader>mx", "<cmd>CMakeStop<cr>", { desc = "CMake Stop" })
map("n", "<leader>ms", "<cmd>CMakeSelectLaunchTarget<cr>", { desc = "Select CMake Target" })

-- ThePrimeagen half-page jump + screen centering remaps
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })

vim.keymap.set("i", "<C-c>", "<Esc>", { desc = "Exit Insert Mode Safely" })

-- DAP bind
map("n", "<leader>dd", function()
  -- 1. Save current file
  vim.cmd("write")

  -- 2. Get file paths
  local file = vim.fn.expand("%:p")
  local basename = vim.fn.expand("%:t:r")
  local outfile = vim.fn.expand("%:p:h") .. "/" .. basename

  -- 3. Compile with debug symbols and no optimizations
  local cmd = string.format("g++ -g -O0 %s -o %s", vim.fn.shellescape(file), vim.fn.shellescape(outfile))
  local result = vim.fn.system(cmd)

  -- 4. Check for compilation errors
  if vim.v.shell_error ~= 0 then
    vim.notify("Compilation failed:\n" .. result, vim.log.levels.ERROR)
    return
  end

  vim.notify("Compiled! Starting DAP...", vim.log.levels.INFO)

  -- 5. Launch nvim-dap
  require("dap").run({
    type = "codelldb", -- Change to "gdb" if you prefer GDB as your adapter backend
    request = "launch",
    name = "Competitive Programming Debug",
    program = outfile,
    cwd = "${workspaceFolder}",
    stopOnEntry = false,
    -- If your CP program reads from input.txt locally, you can redirect it automatically:
    -- stdio = { vim.fn.expand("%:p:h") .. "/input.txt", nil, nil }
  })
end, { desc = "Compile and Debug C++" })
