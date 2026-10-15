-- Mostly LazyVim's defaults: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.g.autoformat = false -- format on save (toggle with <leader>uf / <leader>uF)
vim.g.snacks_animate = false -- no animations (smooth scroll etc.)

-- Native message/cmdline UI (replaces noice.nvim): no "Press ENTER", highlighted cmdline, `g<` pager.
require("vim._core.ui2").enable({})

local opt = vim.opt

opt.autowrite = true
-- Sync with system clipboard, except over SSH where OSC 52 is used on demand
opt.clipboard = vim.env.SSH_CONNECTION and "" or "unnamedplus"
opt.completeopt = { "menuone", "noinsert", "popup", "fuzzy" }
opt.conceallevel = 2
opt.confirm = true
opt.cursorline = true
opt.expandtab = true
opt.fillchars = { foldopen = "\u{f078}", foldclose = "\u{f054}", fold = " ", foldsep = " ", diff = "╱", eob = " " }
opt.foldlevel = 99
opt.foldmethod = "indent"
opt.foldtext = ""
opt.formatoptions = "jqlnt" -- no auto comment leader on <CR>/o/O
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"
opt.ignorecase = true
opt.inccommand = "nosplit"
opt.jumpoptions = "view"
opt.laststatus = 3
opt.linebreak = true
opt.list = false
opt.mouse = "a"
opt.number = true
opt.pumblend = 10
opt.pumheight = 10
opt.pummaxwidth = 60
opt.relativenumber = true
opt.ruler = false
opt.scrolloff = 4
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }
opt.shiftround = true
opt.shiftwidth = 2
opt.shortmess:append({ W = true, I = true, c = true, C = true })
opt.showmode = false
opt.sidescrolloff = 8
opt.signcolumn = "yes"
opt.smartcase = true
opt.smartindent = true
opt.smoothscroll = true
opt.spelllang = { "en" }
opt.splitbelow = true
opt.splitkeep = "screen"
opt.splitright = true
opt.tabstop = 2
opt.timeoutlen = 300
opt.undofile = true
opt.undolevels = 10000
opt.updatetime = 200
opt.virtualedit = "block"
opt.wildmode = "longest:full,full"
opt.winborder = "rounded"
opt.winminwidth = 5
opt.wrap = false

vim.lsp.log.set_level("off")
