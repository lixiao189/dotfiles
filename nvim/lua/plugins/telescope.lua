return {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.6',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = "files" })
        vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = "grep" })
        vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = "buffers" })
        require('telescope').setup {
            defaults = {
                mappings = {
                    n = {
                        ['<c-d>'] = require('telescope.actions').delete_buffer
                    },
                    i = {
                        ["<C-h>"] = "which_key",
                        ['<c-d>'] = require('telescope.actions').delete_buffer
                    }
                }
            },
        }
    end
}
