return {
    -- Theme
    {
        "catppuccin/nvim",
        name = "catppuccin",
        event = "VeryLazy",
        opts = {}
    },
    {
        "olimorris/onedarkpro.nvim",
        priority = 1000,
        init = function()
            vim.cmd("colorscheme onedark")
        end,
        opts = {
            options = {
                transparency = true,
                lualine_transparency = false
            }
        }
    },
    {
        "EdenEast/nightfox.nvim",
        event = "VeryLazy",
        opts = {
            options = { transparent = true }
        }
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
        'romgrk/barbar.nvim',
        dependencies = {
            'lewis6991/gitsigns.nvim',
            'nvim-tree/nvim-web-devicons',
        },
        init = function()
            vim.g.barbar_auto_setup = false
        end,
        config = function()
            require 'barbar'.setup {
                animation = false,
                icons = {
                    buffer_index = true,
                }
            }

            local map = vim.api.nvim_set_keymap
            local opts = { noremap = true, silent = true }
            -- Re-order to previous/next
            map('n', '<A-<>', '<Cmd>BufferMovePrevious<CR>', opts)
            map('n', '<A->>', '<Cmd>BufferMoveNext<CR>', opts)
            -- Goto buffer in position...
            map('n', '<A-1>', '<Cmd>BufferGoto 1<CR>', opts)
            map('n', '<A-2>', '<Cmd>BufferGoto 2<CR>', opts)
            map('n', '<A-3>', '<Cmd>BufferGoto 3<CR>', opts)
            map('n', '<A-4>', '<Cmd>BufferGoto 4<CR>', opts)
            map('n', '<A-5>', '<Cmd>BufferGoto 5<CR>', opts)
            map('n', '<A-6>', '<Cmd>BufferGoto 6<CR>', opts)
            map('n', '<A-7>', '<Cmd>BufferGoto 7<CR>', opts)
            map('n', '<A-8>', '<Cmd>BufferGoto 8<CR>', opts)
            map('n', '<A-9>', '<Cmd>BufferGoto 9<CR>', opts)
            map('n', '<A-0>', '<Cmd>BufferLast<CR>', opts)
        end,
        version = '^1.0.0',
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
            scope = { enabled = false },
            exclude = { filetypes = { "alpha" } }
        }
    },
}
