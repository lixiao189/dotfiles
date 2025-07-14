vim.lsp.enable("vtsls")

return {
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    optional = true,
    opts = { ensure_installed = { "vtsls" } },
  },
}
