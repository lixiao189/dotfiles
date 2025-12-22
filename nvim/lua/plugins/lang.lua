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
        },
      },
    },
  },

  {
    "folke/noice.nvim",
    opts = {
      lsp = {
        signature = {
          enabled = false,
        },
      },
    },
  },

  {
    "saghen/blink.cmp",
    opts = {
      completion = {
        menu = {
          -- Delay before showing the completion menu while typing
          auto_show_delay_ms = 600,
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 1000,
        },
      },
    },
  },
}
