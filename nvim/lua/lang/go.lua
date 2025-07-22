-- Enable when golang is installed
if vim.fn.executable("go") == 0 then
  return {}
end

return {
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    optional = true,
    opts = {
      ensure_installed = { "gopls", "goimports", "gofumpt" },
    },
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        go = { "goimports", "gofumpt" },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, _)
      local gopls = {}
      gopls = require("utils.lang").extend_capabilities(gopls)
      vim.lsp.config("gopls", gopls)
      vim.lsp.enable("gopls")
    end,
  },
}
