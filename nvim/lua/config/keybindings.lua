local keyset = vim.keymap.set

keyset("n", "<leader>q", "<cmd>bd<cr>", { silent = true, noremap = true, desc = "quit" })
