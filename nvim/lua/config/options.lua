-- enable line number and relative line number
vim.opt.number = true
vim.opt.relativenumber = true

-- width of a tab
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4

-- split
vim.opt.splitbelow = true
vim.opt.splitright = true

-- use number of spaces to insert a <Tab>
vim.opt.expandtab = true

-- optionally enable 24-bit colour
vim.opt.termguicolors = true

-- Leaderkey
vim.g.mapleader = " "

-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Improve performance
vim.opt.showcmd = false
vim.opt.ruler = false
vim.opt.updatetime = 100

-- Turn off backup
vim.opt.backup = false
vim.opt.writebackup = false

-- Turn on signcolumn
vim.opt.signcolumn = "yes"

-- Don't show mode
vim.opt.showmode = false

-- No wrap
vim.opt.wrap = false

-- Cursor type
vim.opt.guicursor = "n-v-i-c:block"
