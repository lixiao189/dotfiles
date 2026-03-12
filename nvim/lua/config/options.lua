-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.ai_cmp = false -- Disable ai in cmp nvim
vim.opt.list = false

-- Better performance
vim.lsp.log.set_level("off")
vim.g.snacks_animate = false -- Disable all animations in ssh

-- Vs code config
if vim.g.vscode then
  vim.opt.showmode = true
end
