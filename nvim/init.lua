if vim.fn.has("nvim-0.12") == 0 then
  vim.api.nvim_echo({ { "This config requires Neovim >= 0.12", "ErrorMsg" } }, true, {})
  return
end

require("config.options")
require("config.lazy")
require("config.keymaps")
require("config.autocmds")
