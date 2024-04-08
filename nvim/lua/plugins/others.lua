return {
    "mg979/vim-visual-multi",

    {
        "olimorris/onedarkpro.nvim",
        priority = 1000, -- Ensure it loads first
        init = function()
            vim.cmd("colorscheme onedark")
        end,
        opts = {
            options = {
                transparency = true
            }
        }
    },

    {
        'folke/todo-comments.nvim',
        event = 'VimEnter',
        dependencies = { 'nvim-lua/plenary.nvim' },
        opts = { signs = false }
    },

    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        config = true
    },

    -- Dashboard
    {
        'nvimdev/dashboard-nvim',
        event = 'VimEnter',
        opts = {},
        dependencies = { { 'nvim-tree/nvim-web-devicons' } }
    },

    -- Statusline
    {
        'nvim-lualine/lualine.nvim',
        dependencies = {
            'nvim-tree/nvim-web-devicons',
            'arkav/lualine-lsp-progress'
        },
        opts = {
            options = {
                icons_enabled = true,
                section_separators = '',
                component_separators = '', -- Disable the separator
                disabled_filetypes = {
                    statusline = { "NvimTree", "help" },
                },
            },
            sections = { lualine_c = { 'lsp_progress' } },
        }
    },

    {
        'akinsho/bufferline.nvim',
        version = "*",
        dependencies = 'nvim-tree/nvim-web-devicons',
        opts = {
            options = {
                diagnostics = "coc",
                offsets = {
                    {
                        filetype = "NvimTree",
                        text = "File Explorer",
                        highlight = "Directory",
                    }
                }
            }
        }
    },

    -- Vim notify
    {
        "rcarriga/nvim-notify",
        init = function()
            vim.notify = require("notify")
        end,
    },

    {
        "aserowy/tmux.nvim",
        config = {
            copy_sync = { enable = false },
        }
    },

    {
        "nvim-tree/nvim-tree.lua",
        version = "*",
        lazy = false,
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            vim.keymap.set("n", "<leader>e", "<CMD>NvimTreeToggle<CR>",
                { silent = true, noremap = true, desc = "Explorer NeoTree (root dir)" })
            vim.keymap.set("n", "<leader>E", "<CMD>NvimTreeFindFileToggle<CR>",
                { silent = true, noremap = true, desc = "Explorer NeoTree (cwd)" })
            require("nvim-tree").setup {
                renderer = { group_empty = true }
            }
        end,
    },

    -- Indent lines
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        opts = {
            scope = { enabled = false },
            exclude = { filetypes = { "dashboard" } }
        }
    },

    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        opts = {
            suggestion = {
                auto_trigger = true,
                keymap = { accept = "<C-J>" }
            }
        }
    },

    {
        'numToStr/Comment.nvim',
        lazy = false,
        config = true
    },

    {
        "kylechui/nvim-surround",
        event = { "BufReadPre", "BufNewFile" },
        version = "*",
        config = true,
    },

    {
        "szw/vim-maximizer",
        config = function()
            vim.keymap.set("n", "<leader>m", "<CMD>MaximizerToggle<CR>",
                { silent = true, noremap = true, desc = "Maximize current window" })
        end
    }
}
