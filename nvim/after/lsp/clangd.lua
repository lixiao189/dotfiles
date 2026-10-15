---@type vim.lsp.Config
return {
  capabilities = {
    textDocument = {
      -- Fix-it items (e.g. `ptr->get` rewritten to `ptr.get`) start their edit before the cursor word.
      -- vim.lsp.completion then clears from that column for every snippet item, eating the `->`.
      completion = { editsNearCursor = false },
    },
  },
  init_options = {
    usePlaceholders = true,
    completeUnimported = true,
    clangdFileStatus = true,
  },
}
