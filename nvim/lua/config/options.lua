-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.autoformat = false -- Disable autoformat
vim.g.ai_cmp = false -- Disable ai in cmp nvim
vim.opt.spelllang = { "en", "cjk" } -- Add cjk to spelllang
vim.opt.clipboard = "" -- Set clipboard to empty
vim.opt.list = false
vim.opt.guicursor = "n-v-i-c:block-Cursor"

-- Better performance
vim.lsp.set_log_level("off")
vim.g.matchparen_timeout = 2
vim.g.matchparen_insert_timeout = 2
