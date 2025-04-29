return {
  -- Swift lang
  "keith/swift.vim",
  {
    "rafamadriz/friendly-snippets",
    enabled = false,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = false },
      document_highlight = { enabled = false },
      servers = {
        sourcekit = {
          mason = false,
        },
        gopls = {
          settings = {
            gopls = {
              semanticTokens = false, -- Turn off semantic token highlight
            },
          },
        },
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        swift = { "swiftformat" }, -- Install with brew
      },
    },
  },
}
