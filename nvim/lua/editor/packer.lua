vim.cmd [[packadd packer.nvim]]

return require('packer').startup {
    function(use)
        -- Packer can manage itself
        use 'wbthomason/packer.nvim'

        use 'famiu/bufdelete.nvim'
        use 'dstein64/vim-startuptime'
        use 'nvim-lua/plenary.nvim'

        use {
            'akinsho/bufferline.nvim',
            config = function()
                require("bufferline").setup {
                    options = {
                        close_command = "Bdelete! %d", -- can be a string | function, see "Mouse actions"
                        right_mouse_command = "Bdelete! %d", -- can be a string | function, see "Mouse actions"
                        diagnostics_update_in_insert = true,
                        diagnostics = "nvim_lsp",
                    }
                }
            end
        }
        use {
            'goolord/alpha-nvim',
            requires = { 'nvim-tree/nvim-web-devicons' },
            config = function()
                require 'alpha'.setup(require 'alpha.themes.startify'.config)
            end
        }

        -- The search and replace plugin
        use {
            'windwp/nvim-spectre',
            config = function()
                require('spectre').setup()
            end
        }

        -- Status line plugin
        use {
            'nvim-lualine/lualine.nvim',
            config = function()
                require('lualine').setup {
                    options = {
                        theme = 'catppuccin',
                        disabled_filetypes = { 'neo-tree', 'lspsagaoutline', 'qf', 'alpha' },
                        section_separators = '',
                        component_separators = ''
                    },
                }
            end
        }

        -- Notify plugin
        use {
            'rcarriga/nvim-notify',
            config = function()
                vim.notify = require("notify")
                require("notify").setup({
                    background_colour = "#000000",
                })
                -- Enable telescope support
                require("telescope").load_extension("notify")
            end
        }

        -- tags plugin
        use 'ludovicchabant/vim-gutentags'
        use {
            'skywind3000/gutentags_plus',
            config = function()
                vim.g.gutentags_modules = { 'ctags', 'gtags_cscope' }
                vim.g.gutentags_plus_switch = 1
                vim.g.gutentags_project_root = { '.root', '.git' }
                vim.g.gutentags_cache_dir = vim.fn.expand('~/.cache/tags')
                vim.g.gutentags_plus_nomap = 1
            end
        }

        -- The lsp support
        use 'neovim/nvim-lspconfig'
        use 'hrsh7th/nvim-cmp'
        use 'hrsh7th/cmp-nvim-lsp'
        use 'hrsh7th/cmp-buffer'
        use 'onsails/lspkind-nvim'
        use 'saadparwaiz1/cmp_luasnip' -- Snippets source for nvim-cmp
        use 'L3MON4D3/LuaSnip' -- Snippets plugin
        use 'hrsh7th/cmp-cmdline'
        use 'folke/neodev.nvim'
        use 'williamboman/mason-lspconfig.nvim'
        use 'jayp0521/mason-null-ls.nvim'
        use 'jose-elias-alvarez/null-ls.nvim'
        use "williamboman/mason.nvim"
        use {
            'ray-x/lsp_signature.nvim',
            config = function()
                require("lsp_signature").setup {
                    bind = true,
                    hint_enable = false,
                }
            end
        }
        use {
            'Shatur/neovim-cmake',
            requires = { "mfussenegger/nvim-dap" },
            config = function()
                require('cmake').setup {
                }
            end
        }
        use {
            'folke/trouble.nvim',
            config = function()
                require('trouble').setup()
            end
        }
        use({
            "glepnir/lspsaga.nvim",
            branch = "main",
            config = function()
                require('lspsaga').setup {
                    lightbulb = {
                        sign = false,
                    },
                }
            end,
        })

        -- The plugin for key bindings
        use 'folke/which-key.nvim'

        -- Lsp colorized
        use {
            'norcalli/nvim-colorizer.lua',
            config = function()
                require 'colorizer'.setup()
            end
        }

        -- The markdown previewer with web browser
        use {
            "iamcco/markdown-preview.nvim",
            run = function() vim.fn["mkdp#util#install"]() end,
        }

        -- Latex support
        use {
            'lervag/vimtex',
            config = function()
                vim.g.vimtex_compiler_latexmk_engines = {
                    ['_'] = '-xelatex'
                }
                vim.g.vimtex_view_method = "skim"
            end
        }

        -- The git tui client
        use {
            'TimUntersberger/neogit',
            requires = 'nvim-lua/plenary.nvim',
            config = function()
                require('neogit').setup {}
            end
        }
        use {
            'akinsho/git-conflict.nvim',
            config = function()
                require('git-conflict').setup()
            end
        }
        -- Show the diff signs of the git
        use {
            'lewis6991/gitsigns.nvim',
            config = function()
                require('gitsigns').setup {
                    signs = {
                        untracked = { text = '│' },
                    }
                }
            end
        }

        -- The telescope support
        use 'nvim-telescope/telescope.nvim'

        -- Auto pairs
        use {
            'windwp/nvim-autopairs',
            config = function()
                require('nvim-autopairs').setup()
            end
        }


        -- The file manager
        use {
            "nvim-neo-tree/neo-tree.nvim",
            branch = "v2.x",
            requires = {
                'nvim-tree/nvim-web-devicons', -- for file icons
                "MunifTanjim/nui.nvim",
                { 's1n7ax/nvim-window-picker', tag = "v1.*" }
            }
        }

        -- Tree sitter plugin
        use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
        use 'windwp/nvim-ts-autotag'
        use 'JoosepAlviste/nvim-ts-context-commentstring'
        use {
            'nvim-treesitter/nvim-treesitter-context',
            config = function()
                require 'treesitter-context'.setup {}
            end
        }

        -- The commenter
        use {
            'numToStr/Comment.nvim',
            config = function()
                require('Comment').setup {
                    pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
                }
            end
        }

        -- The indent plugin
        use {
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
        }

        -- The plugin to solve cutting problem
        use { 'gbprod/cutlass.nvim',
            config = function()
                require("cutlass").setup {
                    cut_key = 'x',
                    override_del = 'd',
                }
            end
        }

        -- Themes
        use { "catppuccin/nvim", as = "catppuccin" }
    end,

    config = {
        -- Setup git mirrors
        git = {
            default_url_format = 'https://ghproxy.com/https://github.com/%s'
        }
    }
}
