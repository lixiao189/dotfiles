-- Install when node is installed
if vim.fn.executable("node") == 0 then
  return {}
end

return {
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    optional = true,
    opts = { ensure_installed = { "vtsls" } },
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, _)
      vim.lsp.config("vtsls", vtsls)
    end,
  },
}
