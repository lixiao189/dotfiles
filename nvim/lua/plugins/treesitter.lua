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
                disable = function(_, buf)
                    local max_filesize = 100 * 1024 -- 100 KB
                    ---@diagnostic disable-next-line: undefined-field
                    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                    if ok and stats and stats.size > max_filesize then
                        return true
                    end
                end,
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
