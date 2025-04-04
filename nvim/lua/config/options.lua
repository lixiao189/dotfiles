-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.ai_cmp = false -- Disable ai in cmp nvim
vim.opt.clipboard = "" -- Set clipboard to empty
vim.opt.list = false

-- Better performance
vim.g.snacks_animate = false -- Disable all animations
vim.g.autoformat = false -- Disable autoformat
vim.lsp.set_log_level("off")
