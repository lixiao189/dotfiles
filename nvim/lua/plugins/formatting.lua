local util = require("config.util")

local prettier = { "prettier" }
require("conform").setup({
  default_format_opts = { lsp_format = "fallback", timeout_ms = 3000 },
  formatters_by_ft = {
    lua = { "stylua" },
    sh = { "shfmt" },
    bash = { "shfmt" },
    zsh = { "shfmt" },
    go = { "goimports", "gofumpt" },
    python = { "ruff_organize_imports", "ruff_format" },
    rust = { "rustfmt" },
    c = { "clang-format" },
    cpp = { "clang-format" },
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
  format_on_save = function(buf)
    if util.autoformat_enabled(buf) then
      return {}
    end
  end,
})

vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

vim.keymap.set({ "n", "x" }, "<leader>cf", function()
  util.format()
end, { desc = "Format" })
vim.keymap.set({ "n", "x" }, "<leader>cF", function()
  util.format({ formatters = { "injected" }, timeout_ms = 3000 })
end, { desc = "Format Injected Langs" })
