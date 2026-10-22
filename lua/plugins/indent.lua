return {
  -- Automatically detects indent settings (tabs vs spaces, tab stop length) per file
  {
    "tpope/vim-sleuth",
    event = "BufReadPre",
  },
}
