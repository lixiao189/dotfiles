local pyright = {
  settings = {
    pyright = {
      -- Using Ruff's import organizer
      disableOrganizeImports = true,
    },
    python = {
      analysis = {
        -- Ignore all files for analysis to exclusively use Ruff for linting
        ignore = { "*" },
      },
    },
  },
}
pyright = require("utils.lang").extend_capabilities(pyright)
vim.lsp.enable("ruff")
vim.lsp.enable("pyright")
vim.lsp.config("pyright", pyright)
return {
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    optional = true,
    opts = {
      ensure_installed = { "lua-language-server", "stylua" },
    },
  },
}
