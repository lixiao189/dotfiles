return {
    {
        'bennypowers/nvim-regexplainer',
        dependencies = { 'MunifTanjim/nui.nvim' },
        config = function() require 'regexplainer'.setup() end,
    },

    -- Tree sitter plugin
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        config = function()
            -- Use git to download parsers
            require("nvim-treesitter.install").prefer_git = true

            for _, config in pairs(require("nvim-treesitter.parsers").get_parser_configs()) do
                config.install_info.url = config.install_info.url:gsub("https://github.com/",
                    "https://ghproxy.com/https://github.com/")
            end

            require 'nvim-treesitter.configs'.setup {
                ensure_installed = {
                    "c", "vim", "lua", "cpp", "go", "python", "javascript", "html", "css",
                    "typescript", "vue", "cmake", "markdown", "markdown_inline", "bash", "regex"
                },

                -- Install languages synchronously (only applied to `ensure_installed`)
                sync_install = false,

                autotag = {
                    enable = true,
                },

                indent = {
                    enable = true
                },

                -- List of parsers to ignore installing
                ignore_install = { 'latex' },
                highlight = {
                    -- `false` will disable the whole extension
                    enable = true,
                    -- list of language that will be disabled
                    disable = { 'latex' },
                    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
                    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
                    -- Using this option may slow down your editor, and you may see some duplicate highlights.
                    -- Instead of true it can also be a list of languages
                    additional_vim_regex_highlighting = false,
                },
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = "<CR>",
                        node_incremental = "<CR>",
                        scope_incremental = "<C-A>",
                        node_decremental = "<BS>",
                    },
                },
                context_commentstring = {
                    enable = true,
                    enable_autocmd = false,
                }
            }
        end
    },

    'windwp/nvim-ts-autotag',
    'JoosepAlviste/nvim-ts-context-commentstring',

    {
        "danymat/neogen",
        dependencies = "nvim-treesitter/nvim-treesitter",
        config = true,
        version = "*"
    }
}
