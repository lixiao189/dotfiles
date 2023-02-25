vim.g.vim_json_conceal = 0
vim.g.mapleader = ' '

vim.o.relativenumber = true

vim.o.scrolloff = 8
vim.o.sidescrolloff = 8

vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.cindent = true
vim.o.autoindent = true
vim.o.showmode = false

vim.o.shortmess = vim.o.shortmess .. "I"
vim.o.pumheight = 10
vim.o.mouse = "a"
-- vim.o.guicursor = "i:hor1"
vim.o.cursorline = true
vim.o.laststatus = 2
vim.o.expandtab = true
vim.o.wrap = false
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.spelllang = vim.o.spelllang .. ",cjk"
vim.o.updatetime = 200
vim.o.fillchars = vim.o.fillchars .. "eob: "
vim.o.termguicolors = true
vim.o.numberwidth = 4 -- set number column width to 2 {default 4}
vim.o.signcolumn = "yes" -- always show the sign column otherwise it would shift the text each time
vim.o.splitbelow = true -- force all horizontal splits to go below current window
vim.o.splitright = true -- force all vertical splits to go to the right of current window
vim.o.smartcase = true -- smart case
vim.o.smartindent = true -- make indenting smarter again
vim.o.title = true -- set the title of window to the value of the title string
vim.o.titlestring = "nvim" -- what the title of the window will be set to
vim.o.pumheight = 10 -- pop up menu height
vim.o.swapfile = false -- creates a swap file
vim.o.writebackup = false -- if a file is being edited by another program (or was written to file while editing with another program) it is not allowed to be edited

vim.o.foldmethod = "expr"
vim.o.foldlevel = 99
vim.o.foldexpr = "nvim_treesitter#foldexpr()"

vim.o.completeopt = "menu,menuone,noselect"
vim.o.ignorecase = true -- ignorecase in auto completion

-- Disable underline
vim.lsp.handlers["textDocument/publishDiagnostics"] =
    vim.lsp.with(
        vim.lsp.diagnostic.on_publish_diagnostics, {
        underline = false
    })

vim.cmd [[
    syntax on
    filetype plugin indent on " required
    autocmd FileType go setlocal noexpandtab
    autocmd FileType vim,c,cpp,vue,html,css,ts,yaml,javascript,json,typescript,astro setlocal tabstop=2 shiftwidth=2
]]

-- Keybindings
local function map(mode, lhs, rhs)
    vim.api.nvim_set_keymap(mode, lhs, rhs, { noremap = true, silent = true })
end

-- Moving to beginning and the end
map("n", "L", "$")
map("n", "H", "^")
map("v", "L", "$")
map("v", "H", "^")

-- Moving to previous line
map("n", "K", ":m-2<CR>")
map("n", "J", ":m+<CR>")

-- Use esc to stop highlighting
map("n", "<esc>", "<CMD>noh<CR>")

map("v", "<<", "<gv");
map("v", ">>", ">gv");

-- Preview quickfix item in split view
vim.cmd [[ autocmd! FileType qf nnoremap <buffer> <leader><Enter> <C-w><Enter><C-w>L ]]
