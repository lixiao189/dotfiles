---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<enter>",
        node_incremental = "<enter>",
        scope_incremental = false,
        node_decremental = "<bs>",
      },
    },
  },
}
