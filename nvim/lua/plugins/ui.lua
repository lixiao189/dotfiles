return {
    {
        "neanias/everforest-nvim",
        version = false,
        lazy = false,
        priority = 1000, -- make sure to load this before all the other start plugins
        -- Optional; default configuration will be used if setup isn't called.
        config = function()
            require("everforest").setup({
            })
            vim.opt.background = "dark"
            vim.cmd("colorscheme everforest")
        end,
    },

    -- Icons
    { "nvim-tree/nvim-web-devicons", lazy = true },

    -- Dashboard
    {
        'goolord/alpha-nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            require 'alpha'.setup(require 'alpha.themes.startify'.config)
        end
    },

    -- Statusline
    {
        'nvim-lualine/lualine.nvim',
        event = "VeryLazy",
        dependencies = {
            'nvim-tree/nvim-web-devicons',
        },
        opts = {
            options = {
                icons_enabled = true,
                section_separators = '',
                component_separators = '', -- Disable the separator
                disabled_filetypes = {
                    statusline = { "NvimTree", "help", "alpha" },
                },
                refresh = {
                    statusline = 100,
                }
            },
            sections = { lualine_c = { 'filename', 'g:coc_status' } }
        }
    },

    {
        'akinsho/bufferline.nvim',
        dependencies = {
            'nvim-tree/nvim-web-devicons',
        },
        version = "*",
        config = function()
            require("bufferline").setup {
                options = {
                    numbers = "ordinal",
                    diagnostics = "coc",
                    separator_style = { "", "" },
                },
            }

            local map = vim.api.nvim_set_keymap
            local opts = { noremap = true, silent = true }
            -- Goto buffer in position...
            map('n', '<A-1>', '<Cmd>BufferLineGoToBuffer 1<CR>', opts)
            map('n', '<A-2>', '<Cmd>BufferLineGoToBuffer 2<CR>', opts)
            map('n', '<A-3>', '<Cmd>BufferLineGoToBuffer 3<CR>', opts)
            map('n', '<A-4>', '<Cmd>BufferLineGoToBuffer 4<CR>', opts)
            map('n', '<A-5>', '<Cmd>BufferLineGoToBuffer 5<CR>', opts)
            map('n', '<A-6>', '<Cmd>BufferLineGoToBuffer 6<CR>', opts)
            map('n', '<A-7>', '<Cmd>BufferLineGoToBuffer 7<CR>', opts)
            map('n', '<A-8>', '<Cmd>BufferLineGoToBuffer 8<CR>', opts)
            map('n', '<A-9>', '<Cmd>BufferLineGoToBuffer 9<CR>', opts)
            map('n', '<A-0>', '<Cmd>BufferLineGoToBuffer -1<CR>', opts)
        end,
    },

    -- Vim notify
    {
        "rcarriga/nvim-notify",
        init = function()
            vim.notify = require("notify")
        end,
        config = function()
            require("notify").setup { background_colour = "#000000", }
        end
    },

    -- Indent lines
    {
        "lukas-reineke/indent-blankline.nvim",
        event = {
            "BufReadPre",
            "BufNewFile",
        },
        main = "ibl",
        opts = {
            scope = {
                enabled = true,
                show_start = false,
                show_end = false
            },
            exclude = { filetypes = { "alpha" } }
        }
    },

    -- Highlight the outer pair
    {
        "utilyre/sentiment.nvim",
        version = "*",
        event = "VeryLazy", -- keep for lazy loading
        opts = {
            -- config
        },
        init = function()
            -- `matchparen.vim` needs to be disabled manually in case of lazy loading
            vim.g.loaded_matchparen = 1
        end,
    }
}
