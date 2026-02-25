return {
  -- Swift lang lsp
  {
    "neovim/nvim-lspconfig",
    optional = true,
    opts = {
      inlay_hints = { enabled = false },
      servers = {
        sourcekit = {
          mason = false,
          filetypes = { "swift", "objc", "objcpp" },
        },
      },
    },
  },

  {
    "folke/noice.nvim",
    optional = true,
    opts = {
      lsp = {
        signature = {
          enabled = false,
        },
      },
    },
  },
}
