return {
    -- The git tui client
    {
        'TimUntersberger/neogit',
        dependencies = 'nvim-lua/plenary.nvim',
        config = function()
            require('neogit').setup {}
        end
    },
    {
        'akinsho/git-conflict.nvim',
        config = function()
            require('git-conflict').setup()
        end
    },
    -- Show the diff signs of the git
    {
        'lewis6991/gitsigns.nvim',
        config = function()
            require('gitsigns').setup {
                signs = {
                    untracked = { text = '│' },
                }
            }
        end
    },
}
