-- Install when node is installed
if vim.fn.executable("node") == 0 then
  return {}
end

vim.lsp.enable("vtsls")

return {
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    optional = true,
    opts = { ensure_installed = { "vtsls" } },
  },
}
