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
