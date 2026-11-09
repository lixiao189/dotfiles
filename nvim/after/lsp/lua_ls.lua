---@type vim.lsp.Config
return {
  settings = {
    Lua = {
      completion = { callSnippet = "Replace" },
      hint = { enable = true, setType = false, paramType = true, arrayIndex = "Disable" },
    },
  },
}
