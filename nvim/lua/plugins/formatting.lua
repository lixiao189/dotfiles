local util = require("config.util")

local prettier = { "prettier" }

return {
  "stevearc/conform.nvim",
  event = "BufWritePre",
  cmd = "ConformInfo",
  dependencies = { "mason-org/mason.nvim" },
  keys = {
    {
      "<leader>cf",
      function()
        require("conform").format()
      end,
      mode = { "n", "x" },
      desc = "Format",
    },
    {
      "<leader>cF",
      function()
        require("conform").format({ formatters = { "injected" } })
      end,
      mode = { "n", "x" },
      desc = "Format Injected Langs",
    },
  },
  init = function()
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  end,
  opts = {
    default_format_opts = { lsp_format = "fallback", timeout_ms = 3000 },
    formatters_by_ft = {
      lua = { "stylua" },
      sh = { "shfmt" },
      bash = { "shfmt" },
      zsh = { "shfmt" },
      go = { "goimports", "gofumpt" },
      python = { "ruff_organize_imports", "ruff_format" },
      rust = { "rustfmt" },
      cmake = { "gersemi" },
      javascript = prettier,
      javascriptreact = prettier,
      typescript = prettier,
      typescriptreact = prettier,
      json = prettier,
      jsonc = prettier,
      yaml = prettier,
      markdown = prettier,
      css = prettier,
      html = prettier,
    },
    -- C/C++ has no formatter here: `lsp_format = "fallback"` hands it to clangd,
    -- which honors a project `.clang-format` or its own preset (LLVM).
    format_on_save = function(buf)
      if util.autoformat_enabled(buf) then
        return {}
      end
    end,
  },
}
