-- Move quickly
vim.keymap.set({ 'n', 'v' }, '<S-h>', "^", { remap = true, silent = true, noremap = true })
vim.keymap.set({ 'n', 'v' }, '<S-l>', "$", { remap = true, silent = true, noremap = true })

-- Clear search with <esc>
vim.keymap.set({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and Clear hlsearch" })
