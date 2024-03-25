return {
    "mg979/vim-visual-multi",

    -- Onedark theme
    {
        "olimorris/onedarkpro.nvim",
        priority = 1000, -- Ensure it loads first
        config = function()
            vim.cmd("colorscheme onedark")
        end,
    },

    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        config = function()
            require('nvim-autopairs').setup { map_cr = false }
        end
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
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        opts = {
            options = {
                icons_enabled = true,
                section_separators = '',
                component_separators = '' -- Disable the separator
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
                { silent = true, noremap = true, desc = "Toggle file tree" })
            require("nvim-tree").setup {}
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
    }
}
