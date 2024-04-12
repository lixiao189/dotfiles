return {
    "mg979/vim-visual-multi",

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

    {
        "aserowy/tmux.nvim",
        event = "VeryLazy",
        config = {
            copy_sync = { enable = false },
        }
    },

    {
        "nvim-tree/nvim-tree.lua",
        version = "*",
        event = "VeryLazy",
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
