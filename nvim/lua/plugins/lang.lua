return {
  -- Swift lang
  "keith/swift.vim",
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
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        swift = { "swiftformat" }, -- Install with brew
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = {
      incremental_selection = {
        keymaps = {
          init_selection = "<enter>",
          node_incremental = "<enter>",
        },
      },
    },
  },
}
