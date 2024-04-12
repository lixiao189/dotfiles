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
        event = "VeryLazy",
        opts = {}
    },
    {
        "EdenEast/nightfox.nvim",
        priority = 1000,
        init = function ()
            vim.cmd("colorscheme carbonfox")
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
        dependencies = {
            'nvim-tree/nvim-web-devicons',
        },
        opts = {
            options = {
                icons_enabled = true,
                section_separators = '',
                component_separators = '', -- Disable the separator
                disabled_filetypes = {
                    statusline = { "NvimTree", "help", "aerial" },
                },
            },
        }
    },

    -- Buffer line
    {
        'akinsho/bufferline.nvim',
        version = "*",
        dependencies = 'nvim-tree/nvim-web-devicons',
        opts = {
            options = {
                diagnostics = "nvim_lsp",
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

    -- VS code like winbar
    {
        "utilyre/barbecue.nvim",
        name = "barbecue",
        version = "*",
        dependencies = {
            "SmiteshP/nvim-navic",
            "nvim-tree/nvim-web-devicons", -- optional dependency
        },
        opts = {
            -- configurations go here
        },
    }
}
