return {
  -- 1. Download and configure the automatic transparency plugin
  -- 2. Your Catppuccin theme configuration
  {
    "catppuccin/nvim",
    name = "catppuccin",
    opts = {
      flavour = "mocha",
    },
  },

  -- 3. Tell LazyVim to use Catppuccin
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}
