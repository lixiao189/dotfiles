---@type vim.lsp.Config
return {
  -- v0.22+ leaves this off. lspconfig turns it back on; highlighting is treesitter.
  settings = {
    gopls = {
      semanticTokens = false,
    },
  },
}
