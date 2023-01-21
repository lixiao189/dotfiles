vim.o.foldmethod = "expr"
vim.o.foldlevel = 99
vim.o.foldexpr = "nvim_treesitter#foldexpr()"

-- Use git to download parsers
require("nvim-treesitter.install").prefer_git = true

for _, config in pairs(require("nvim-treesitter.parsers").get_parser_configs()) do
    config.install_info.url = config.install_info.url:gsub("https://github.com/",
        "https://ghproxy.com/https://github.com/")
end

require 'nvim-treesitter.configs'.setup {
    ensure_installed = {
        "c", "lua", "vim", "help", "cpp", "go", "python", "javascript", "typescript",
        "vue", "php", "yaml", "json", "cmake", "rust", "make", "markdown", "latex"
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
    ignore_install = { "phpdoc" },
    highlight = {
        -- `false` will disable the whole extension
        enable = true,

        -- list of language that will be disabled
        disable = { 'vim' },

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
    rainbow = {
        enable = true,
        -- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
        extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
        max_file_lines = nil, -- Do not enable for files with more than n lines, int
        -- colors = {}, -- table of hex strings
        -- termcolors = {} -- table of colour name strings
    },
    context_commentstring = {
        enable = true,
        enable_autocmd = false,
    }
}
