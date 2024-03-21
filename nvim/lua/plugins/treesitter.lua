return {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    init = function()
        vim.opt.foldmethod = 'expr'
        vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
        vim.opt.foldenable = false
    end,
    config = function()
        require('nvim-treesitter.configs').setup {
            ensure_installed = { "c", "cpp", "lua", "vim", "vimdoc", "query", "go", "rust" },
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
            },
        }
    end,
}
