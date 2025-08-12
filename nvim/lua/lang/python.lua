return {
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    optional = true,
    opts = {
      ensure_installed = { "ruff", "pyright" },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, _)
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

      local ruff = {
        on_attach = function(client, _buffer)
          -- Disable hover in favor of Pyright
          client.server_capabilities.hoverProvider = false
        end,
      }

      vim.lsp.enable("ruff")
      vim.lsp.config("ruff", ruff)

      pyright = require("utils.lang").extend_capabilities(pyright)
      vim.lsp.enable("pyright")
      vim.lsp.config("pyright", pyright)
    end,
  },
}
