local map = vim.keymap.set

-- Move quickly
map({ 'n', 'v' }, '<S-h>', "^", { remap = true, silent = true, noremap = true })
map({ 'n', 'v' }, '<S-l>', "$", { remap = true, silent = true, noremap = true })

-- Clear search with <esc>
map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and Clear hlsearch" })

-- Move between windows
map("n", "<C-h>", "<C-w>h", { desc = "Swich to Left Window" })
map("n", "<C-j>", "<C-w>j", { desc = "Swich to Down Window" })
map("n", "<C-k>", "<C-w>k", { desc = "Swich to Up Window" })
map("n", "<C-l>", "<C-w>l", { desc = "Swich to Right Window" })

-- Resize window
map("n", "<A-h>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
map("n", "<A-l>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })
map("n", "<A-j>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
map("n", "<A-k>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })

-- Move between the terminal and the editor
function _G.set_terminal_keymaps()
  local opts = { buffer = 0 }
  vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
  vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
  vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
  vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
  vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
end

vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
