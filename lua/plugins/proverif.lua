-- lua/plugins/proverif.lua

-- 1. Register file extensions
vim.filetype.add({
  extension = {
    pv = "proverif",
    pvl = "proverif",
  },
})

return {
  -- 2. Configure nvim-lspconfig for ProVerif
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        proverif = {
          cmd = { "proverif-lsp" },
          filetypes = { "proverif" },
          root_dir = function(fname)
            return vim.fs.dirname(vim.fs.find({ ".git", "proverif.ini" }, { upward = true, path = fname })[1])
              or vim.fs.dirname(fname)
          end,
        },
      },
    },
  },
}
