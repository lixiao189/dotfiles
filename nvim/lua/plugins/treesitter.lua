return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      highlight = { enable = false },
      indent = { disable = { "c", "cpp", "objc", "objcpp" } }, -- For performance
    },
  },

  -- snacks.quickfile starts treesitter highlighting for the initial file,
  -- bypassing nvim-treesitter's own highlight option
  {
    "folke/snacks.nvim",
    optional = true,
    opts = {
      quickfile = { enabled = false },
    },
  },
}
