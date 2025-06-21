return {
  -- Disable none-ls for some annoying bugs
  {
    "nvimtools/none-ls.nvim",
    enabled = false,
  },
  {
    "AstroNvim/astrolsp",
    ---@type AstroLSPOpts
    opts = {
      features = {
        semantic_tokens = false, -- enable/disable semantic token highlighting
      },
      -- customize language server configuration options passed to `lspconfig`
      ---@diagnostic disable: missing-fields
      config = {
        emmet_ls = {
          enabled = false,
        },
      },
    },
  },
}
