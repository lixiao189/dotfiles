-- enable line number and relative line number
vim.opt.number = true
vim.opt.relativenumber = true

-- width of a tab
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2

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
vim.opt.pumheight = 10

-- Turn off backup
vim.opt.backup = false
vim.opt.writebackup = false

-- Turn on signcolumn
vim.opt.signcolumn = "yes"

-- Don't show mode
vim.opt.showmode = false

-- No wrap
vim.opt.wrap = false

-- Highlight current line
vim.opt.cursorline = true

-- disable some default providers
vim.g.loaded_node_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

-- CLipboard over ssh
local ssh_connection = vim.fn.getenv("SSH_CONNECTION")
if ssh_connection ~= vim.NIL then
  vim.g.clipboard = {
    name = 'OSC 52',
    copy = {
      ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
      ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
    },
    paste = {
      ['+'] = require('vim.ui.clipboard.osc52').paste('+'),
      ['*'] = require('vim.ui.clipboard.osc52').paste('*'),
    },
  }
end
