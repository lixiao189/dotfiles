return {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    dependencies = {
        { "windwp/nvim-ts-autotag", lazy = true }
    },
    config = function()
        require('nvim-treesitter.configs').setup {
            ensure_installed = { "lua", "vim", "vimdoc", "query" },
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
            },
            autotag = {
                enable = true,
            },
            indent = {
                enable = true
            },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<Enter>", -- set to `false` to disable one of the mappings
                    node_incremental = "<Enter>",
                    scope_incremental = false,
                    node_decremental = false,
                },
            },
        }
    end,
}
