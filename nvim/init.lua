-- Neovim >= 0.12 config built on native features:
--   vim.pack (plugins), vim.lsp.config/enable (LSP), vim.lsp.completion (completion),
--   LSP semantic tokens/folds/selection, ui2 (messages/cmdline).
-- Keymaps follow LazyVim: https://www.lazyvim.org/keymaps

if vim.fn.has("nvim-0.12") == 0 then
  vim.api.nvim_echo({ { "This config requires Neovim >= 0.12", "ErrorMsg" } }, true, {})
  return
end

vim.loader.enable()

require("config.options")
require("config.pack")

require("plugins.ui")
require("plugins.statusline")
require("plugins.editor")
require("plugins.lsp")
require("plugins.completion")
require("plugins.formatting")
require("plugins.git")

require("config.keymaps")
require("config.autocmds")
require("config.session")
