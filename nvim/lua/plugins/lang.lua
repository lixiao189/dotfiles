return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = false },
      servers = {
        clangd = {
          init_options = {
            usePlaceholders = true,
            completeUnimported = true,
            clangdFileStatus = true,
          },
        },
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
