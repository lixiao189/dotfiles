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
require("plugins.treesitter")
require("plugins.lsp")
require("plugins.completion")
require("plugins.formatting")
require("plugins.git")

require("config.keymaps")
require("config.autocmds")
