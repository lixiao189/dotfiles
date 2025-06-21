---@type LazySpec
return {
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
    formatting = {
      disabled = { "lua_ls", "vtsls", "astro-language-server" }, -- Use none-ls format buffer
    },
  },
}
