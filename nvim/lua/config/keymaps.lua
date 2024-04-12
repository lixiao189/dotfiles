-- map jj to <ESC> and save file
vim.api.nvim_set_keymap('i', 'jj', '<ESC><cmd>w<cr>', { noremap = true, silent = true })
