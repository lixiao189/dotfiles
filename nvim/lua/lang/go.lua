-- Enable when golang is installed
if vim.fn.executable("go") == 0 then
  return {}
end

local gopls = {}
gopls = require("utils.lang").extend_capabilities(gopls)
vim.lsp.enable("gopls")
vim.lsp.config("gopls", gopls)

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
}
