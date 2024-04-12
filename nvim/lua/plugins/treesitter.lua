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
                    init_selection = "gnn", -- set to `false` to disable one of the mappings
                    node_incremental = "grn",
                    scope_incremental = "grc",
                    node_decremental = "grm",
                },
            },
        }
    end,
}
