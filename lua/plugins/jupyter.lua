vim.api.nvim_create_autocmd("FileType", {
  pattern = { "python", "markdown" },
  callback = function()
    vim.bo.commentstring = "# %s"
  end,
})

return {
  -- 1. Molten Engine
  {
    "benlubas/molten-nvim",
    version = "^1.0.0",
    build = ":UpdateRemotePlugins",
    init = function()
      vim.g.molten_image_provider = "image.nvim"
      vim.g.molten_output_win_max_height = 20
      vim.g.molten_auto_open_output = true
      vim.g.molten_wrap_output = true
      vim.g.molten_virt_text_output = true
      vim.g.molten_virt_lines_off_by_1 = true
      vim.g.molten_save_output_to_file = true
    end,
    keys = {
      {
        "<leader>mi",
        function()
          vim.api.nvim_create_autocmd("User", {
            pattern = "MoltenKernelReady",
            once = true,
            callback = function()
              vim.notify("Jupyter kernel connected!", vim.log.levels.INFO, { title = "Molten" })
            end,
          })
          vim.cmd("MoltenInit python3")
        end,
        desc = "Initialize Molten Kernel",
      },
      { "<leader>oh", ":MoltenHideOutput<CR>", desc = "close output window" },
      { "<leader>md", ":MoltenDelete<CR>", desc = "delete Molten cell" },
      { "<leader>os", ":noautocmd MoltenEnterOutput<CR>", desc = "open output window" },
    },
  },

  -- 2. Quarto
  {
    "quarto-dev/quarto-nvim",
    ft = { "quarto", "markdown", "ipynb" },
    dependencies = {
      "jmbuhr/otter.nvim",
      "neovim/nvim-lspconfig",
    },
    opts = {
      codeRunner = {
        enabled = true,
        default_method = "molten",
      },
    },
    config = function(_, opts)
      local quarto = require("quarto")
      quarto.setup(opts)

      -- CONSOLIDATED AUTOMATIC SEQUENCE ON OPEN
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "markdown", "quarto", "ipynb" },
        callback = function()
          local buf_name = vim.api.nvim_buf_get_name(0)

          -- 🔍 SMART GUARD: Detect if this is an actual notebook file
          local is_notebook = vim.bo.filetype == "quarto"
            or vim.bo.filetype == "ipynb"
            or string.match(buf_name, "%.ipynb$")

          -- If it's a normal markdown file (like README.md), stop here and do nothing!
          if not is_notebook then
            return
          end

          quarto.activate()

          -- Handle workspace rendering and initialization after a brief pause
          vim.defer_fn(function()
            -- 1. Lock onto python3 kernel immediately to prevent prompt popups
            pcall(function()
              vim.cmd("MoltenInit python3")
            end)

            -- 2. Automatically load and display your saved cell outputs
            pcall(function()
              vim.cmd("MoltenImportOutput")
            end)

            -- 3. Turn off the render-markdown UI cleanly so you see raw text blocks
            pcall(function()
              require("render-markdown").disable()
            end)

            -- 4. Keep conceal rules off so backticks and borders stay fully visible
            vim.opt_local.conceallevel = 0
          end, 500)
        end,
      })

      -- Keymaps
      local runner = require("quarto.runner")
      vim.keymap.set("n", "<leader>rc", runner.run_cell, { desc = "run cell" })
      vim.keymap.set("n", "<leader>ra", runner.run_above, { desc = "run cell and above" })
      vim.keymap.set("n", "<leader>rA", runner.run_all, { desc = "run all cells" })

      -- Safe Jupyter Sync & Save
      vim.keymap.set("n", "<leader>js", function()
        local buf_name = vim.api.nvim_buf_get_name(0)
        local ft = vim.bo.filetype

        -- Check if buffer is an .ipynb file OR if molten is active in this buffer
        local is_ipynb = string.match(buf_name, "%.ipynb$") ~= nil
        local is_jupyter_ft = (ft == "markdown" or ft == "python" or ft == "ipynb")

        if is_ipynb or (is_jupyter_ft and vim.g.molten_exported_otter_path) then
          -- Export Molten outputs first
          vim.cmd("MoltenExportOutput!")

          -- Allow Molten time to flush JSON output to disk before writing buffer
          vim.defer_fn(function()
            vim.cmd("write")
            vim.notify("Notebook saved successfully with cell outputs!", vim.log.levels.INFO)
          end, 200)
        else
          vim.cmd("write")
        end
      end, { desc = "Jupyter Save (With Outputs)" })

      -- -- Safe Jupyter Sync & Save
      -- vim.keymap.set("n", "<leader>js", function()
      --   local buf_name = vim.api.nvim_buf_get_name(0)
      --   if vim.bo.filetype == "markdown" and string.match(buf_name, "%.ipynb$") then
      --     vim.cmd("MoltenExportOutput!")
      --     vim.defer_fn(function()
      --       vim.cmd("write")
      --       print("Notebook saved successfully with all cell outputs!")
      --     end, 150)
      --   else
      --     vim.cmd("write")
      --   end
      -- end, { desc = "Jupyter Save (With Outputs)" })
    end,
  },

  -- 3. Jupytext
  {
    "GCBallesteros/jupytext.nvim",
    opts = { style = "markdown", output_extension = "md", force_ft = "markdown" },
    lazy = false,
  },

  -- 4. Image.nvim
  {
    "3rd/image.nvim",
    opts = {
      backend = "kitty",
      max_width = 100,
      max_height = 12,
      max_height_window_percentage = math.huge,
    },
  },
}
