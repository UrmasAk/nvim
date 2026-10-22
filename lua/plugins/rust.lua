return {
  "mrcjkb/rustaceanvim",
  version = "^5",
  lazy = false,
  opts = {
    server = {
      default_settings = {
        ["rust-analyzer"] = {
          cargo = {
            -- 1. Isolates RA's build cache into target/rust-analyzer/
            targetDir = true,
          },
        },
      },
    },
  },
}
