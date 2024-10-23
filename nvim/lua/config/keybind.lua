vim.keymap.set({ 'n', 'v' }, 'H', "^", { remap = true, silent = true, noremap = true })
vim.keymap.set({ 'n', 'v' }, 'L', "$", { remap = true, silent = true, noremap = true })

-- Clear search with <esc>
vim.keymap.set({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and Clear hlsearch" })
