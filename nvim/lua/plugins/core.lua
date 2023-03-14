return {
    'famiu/bufdelete.nvim',
    'nvim-lua/plenary.nvim',
    'danilamihailov/beacon.nvim',

    {
        'phaazon/hop.nvim',
        config = function()
            require 'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }
        end
    },

    {
        "aserowy/tmux.nvim",
        config = function() return require("tmux").setup() end
    },

    {
        {
            'nvim-tree/nvim-web-devicons',
            opts = {
                override = {
                    md = {
                        icon = "",
                        color = "#519aba",
                        cterm_color = "67",
                        name = "Markdown",
                    },
                    log = {
                        icon = "",
                        color = "#6d8086",
                        cterm_color = "66",
                        name = "Log",
                    }
                }
            }
        }
    },


    {
        'karb94/neoscroll.nvim',
        config = true
    },

    {
        'akinsho/bufferline.nvim',
        config = function()
            require("bufferline").setup {
                options = {
                    separator_style = { "", "" },
                    close_command = "Bdelete! %d",    -- can be a string | function, see "Mo actions"
                    right_mo_command = "Bdelete! %d", -- can be a string | function, see "Mouse actions"
                    diagnostics_update_in_insert = true,
                    diagnostics = "nvim_lsp",
                }
            }
        end
    },
    {
        'goolord/alpha-nvim',
        config = function()
            require 'alpha'.setup(require 'alpha.themes.startify'.config)
        end
    },

    -- The search and replace plugin
    {
        'windwp/nvim-spectre',
        config = true
    },

    -- Status line plugin
    {
        'nvim-lualine/lualine.nvim',
        config = function()
            require('lualine').setup {
                options = {
                    theme = 'catppuccin',
                    disabled_filetypes = { 'neo-tree', 'lspsagaoutline', 'qf', 'alpha', 'dbui' },
                    section_separators = '',
                    component_separators = ''
                },
            }
        end
    },

    -- Notify plugin
    {
        'rcarriga/nvim-notify',
        config = function()
            vim.notify = require("notify")
            require("notify").setup({
                background_colour = "#000000",
            })
            -- Enable telescope support
            require("telescope").load_extension("notify")
        end
    },

    -- tags plugin
    'ludovicchabant/vim-gutentags',
    {
        'skywind3000/gutentags_plus',
        config = function()
            vim.g.gutentags_modules = { 'ctags', 'gtags_cscope' }
            vim.g.gutentags_plus_switch = 1
            vim.g.gutentags_project_root = { '.root' }
            vim.g.gutentags_cache_dir = vim.fn.expand('~/.cache/tags')
            vim.g.gutentags_plus_nomap = 1
        end
    },

    -- The plugin for key bindings

    -- Lsp colorized
    {
        'norcalli/nvim-colorizer.lua',
        config = function()
            require 'colorizer'.setup()
        end
    },

    -- The markdown previewer with web browser
    {
        "iamcco/markdown-preview.nvim",
        build = function() vim.fn["mkdp#util#install"]() end,
    },

    -- Latex support
    {
        'lervag/vimtex',
        config = function()
            vim.g.vimtex_compiler_latexmk_engines = {
                ['_'] = '-xelatex'
            }
            vim.g.vimtex_view_method = "skim"
        end
    },


    -- The telescope support
    'nvim-telescope/telescope.nvim',

    -- Auto pairs
    {
        'windwp/nvim-autopairs',
        config = function()
            require('nvim-autopairs').setup()
        end
    },

    -- The file manager
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v2.x",
        dependencies = {
            'nvim-tree/nvim-web-devicons', -- for file icons
            "MunifTanjim/nui.nvim",
            { 's1n7ax/nvim-window-picker', version = "v1.*" }
        }
    },

    -- The commenter
    {
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup {
                pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
            }
        end
    },

    -- The indent plugin
    {
        'lukas-reineke/indent-blankline.nvim',
        config = function()
            vim.g.indent_blankline_filetype_exclude = {
                "lspinfo",
                "mason",
                "help",
                "checkhealth",
                "alpha",
                "packer",
                "qf",
                "neo-tree",
                "lspsagaoutline"
            }

            require("indent_blankline").setup {
                show_current_context = true,
            }
        end
    },

    -- The plugin to solve cutting problem
    {
        'gbprod/cutlass.nvim',
        config = function()
            require("cutlass").setup {
                cut_key = 'x',
                override_del = 'd',
            }
        end
    },

    -- Themes
    {
        "catppuccin/nvim",
        name = "catppuccin",
        config = function()
            vim.cmd('colorscheme catppuccin-mocha')
            require("catppuccin").setup {
                transparent_background = true,
                integrations = {
                    fidget = true,
                    cmp = true,
                    gitsigns = true,
                    telescope = true,
                    notify = true,
                    lsp_saga = true,
                    neotree = true,
                    neogit = true,
                    beacon = true,
                }
            }
        end
    },
}
