local map = vim.keymap.set

-- Move quickly
map({ 'n', 'v' }, '<S-h>', "^", { remap = true, silent = true, noremap = true })
map({ 'n', 'v' }, '<S-l>', "$", { remap = true, silent = true, noremap = true })

-- Clear search with <esc>
map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and Clear hlsearch" })

-- Resize window
map("n", "<A-h>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
map("n", "<A-l>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })
map("n", "<A-j>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
map("n", "<A-k>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
