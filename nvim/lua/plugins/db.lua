return {
    {
        'tpope/vim-dadbod', config = function()
            vim.g.dbs = {}
            vim.g.db_ui_save_location = '~/.config/dbui'
        end
    },
    {
        'kristijanhusak/vim-dadbod-ui',
        after = 'vim-dadbod',
        config = function()
            vim.g.db_ui_use_nerd_fonts = 1
            vim.g.db_ui_win_position = "right"
        end
    },
    {
        'kristijanhusak/vim-dadbod-completion',
        after = 'hrsh7th/nvim-cmp',
        config = function()
            vim.api.nvim_create_autocmd("FileType", {
                pattern = { 'sql', 'mysql', 'plsql' },
                callback = function()
                    require('cmp').setup.buffer({ sources = { { name = 'vim-dadbod-completion' } } })
                end
            })
        end
    }
}
