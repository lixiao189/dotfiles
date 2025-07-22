return {
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  optional = true,
  opts = {
    ensure_installed = { "clangd" },
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, _)
      local clangd = {}
      clangd = require("utils.lang").extend_capabilities(clangd)
      vim.lsp.config("clangd", clangd)
      vim.lsp.enable("clangd")
    end,
  },
}
