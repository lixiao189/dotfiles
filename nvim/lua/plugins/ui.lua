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
        init = function()
            vim.cmd("colorscheme carbonfox")
        end,
    },

    -- Icons
    { "nvim-tree/nvim-web-devicons", lazy = true },

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
        event = {
            "BufReadPre",
            "BufNewFile",
        },
        dependencies = {
            'nvim-tree/nvim-web-devicons',
        },
        opts = {
            options = {
                icons_enabled = true,
                section_separators = '',
                component_separators = '', -- Disable the separator
                disabled_filetypes = {
                    statusline = { "NvimTree", "help", "aerial", "dashboard" },
                },
            },
        }
    },

    -- Buffer line
    {
        "akinsho/bufferline.nvim",
        version = "*",
        event = "VimEnter",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
            "ojroques/nvim-bufdel",
        },
        opts = {
            options = {
                diagnostics = "nvim_lsp",
                close_command = "BufDel",
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
        event = {
            "BufReadPre",
            "BufNewFile",
        },
        name = "barbecue",
        version = "*",
        dependencies = {
            "SmiteshP/nvim-navic",
            "nvim-tree/nvim-web-devicons", -- optional dependency
        },
        config = function()
            require("barbecue").setup({
                create_autocmd = false, -- prevent barbecue from updating itself automatically
            })

            vim.api.nvim_create_autocmd({
                "WinResized",
                "BufWinEnter",
                "CursorHold",
                "InsertLeave",

                -- include this if you have set `show_modified` to `true`
                "BufModifiedSet",
            }, {
                group = vim.api.nvim_create_augroup("barbecue.updater", {}),
                callback = function()
                    require("barbecue.ui").update()
                end,
            })
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
            exclude = { filetypes = { "dashboard" } }
        }
    },
}
