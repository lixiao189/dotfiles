local clangd = {}
clangd = require("utils.lang").extend_capabilities(clangd)
vim.lsp.enable("clangd")
vim.lsp.config("clangd", clangd)

return {
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  optional = true,
  opts = {
    ensure_installed = { "clangd" },
  },
}
