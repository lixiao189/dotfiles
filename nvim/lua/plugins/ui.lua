return {
    {
        "tanvirtin/monokai.nvim",
        priority = 1000,
        lazy = false,
        config = function ()
            vim.cmd[[colorscheme monokai]]
        end
    },

    -- Dashboard
    {
        'goolord/alpha-nvim',
        config = function()
            local startify = require("alpha.themes.startify")
            startify.file_icons.enabled = false
            require 'alpha'.setup(startify.config)
        end
    },

    -- Statusline
    {
        'nvim-lualine/lualine.nvim',
        event = "VeryLazy",
        opts = {
            options = {
                icons_enabled = false,
                section_separators = '',
                component_separators = '', -- Disable the separator
                disabled_filetypes = {
                    statusline = { "NvimTree", "help", "alpha" },
                },
                refresh = {
                    statusline = 100,
                }
            },
        }
    },

    {
        'akinsho/bufferline.nvim',
        version = "*",
        config = function()
            require("bufferline").setup {
                options = {
                    numbers = "ordinal",
                    separator_style = { "", "" },
                    buffer_close_icon = '󰅖',
                    close_icon = '󰅖'
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

    -- Indent lines
    -- {
    --     "lukas-reineke/indent-blankline.nvim",
    --     event = {
    --         "BufReadPre",
    --         "BufNewFile",
    --     },
    --     main = "ibl",
    --     opts = {
    --         scope = {
    --             enabled = true,
    --             show_start = false,
    --             show_end = false
    --         },
    --         exclude = { filetypes = { "alpha" } }
    --     }
    -- },
}
