-- Install when node is installed
if vim.fn.executable("node") then
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
