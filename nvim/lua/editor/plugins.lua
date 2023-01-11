vim.cmd [[packadd packer.nvim]]

local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
    packer_bootstrap = fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim',
        install_path })
end

-- Run PackerCompile automatically
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    use 'akinsho/bufferline.nvim'
    use 'famiu/bufdelete.nvim'
    use 'antoinemadec/FixCursorHold.nvim'
    use 'dstein64/vim-startuptime'
    use 'nvim-lua/plenary.nvim'

    -- The welcome plugin
    use 'glepnir/dashboard-nvim'

    -- The search and replace plugin
    use {
        'windwp/nvim-spectre',
        config = function()
            require('spectre').setup()
        end
    }

    -- Status line plugin
    use 'nvim-lualine/lualine.nvim'

    -- Notify plugin
    use 'rcarriga/nvim-notify'

    -- The lsp support
    use 'neovim/nvim-lspconfig'
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use 'onsails/lspkind-nvim'
    use 'saadparwaiz1/cmp_luasnip' -- Snippets source for nvim-cmp
    use 'L3MON4D3/LuaSnip' -- Snippets plugin
    use 'simrat39/symbols-outline.nvim'
    use 'ray-x/lsp_signature.nvim'
    use 'hrsh7th/cmp-cmdline'
    use 'folke/neodev.nvim'
    use 'williamboman/mason-lspconfig.nvim'
    use 'jayp0521/mason-null-ls.nvim'
    use 'jose-elias-alvarez/null-ls.nvim'
    use {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
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

    -- The plugin for key bindings
    use 'folke/which-key.nvim'

    -- Inner terminal
    use {
        'akinsho/toggleterm.nvim',
        config = function()
            require("toggleterm").setup()
        end
    }

    -- The markdown previewer
    use {
        "ellisonleao/glow.nvim",
        branch = 'main',
        run = ':GlowInstall'
    }

    -- The markdown previewer with web browser
    use({
        "iamcco/markdown-preview.nvim",
        run = function() vim.fn["mkdp#util#install"]() end,
    })



    -- The git tui client
    use 'kdheepak/lazygit.nvim'
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
            require('gitsigns').setup()
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


    use 'p00f/nvim-ts-rainbow'

    -- The file manager
    use 'kyazdani42/nvim-web-devicons' -- for file icons
    use 'kyazdani42/nvim-tree.lua'

    -- Tree sitter plugin
    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
    use 'windwp/nvim-ts-autotag'
    use 'JoosepAlviste/nvim-ts-context-commentstring'
    use {
        'lewis6991/spellsitter.nvim',
        config = function()
            require('spellsitter').setup()
        end
    }
    use {
        'nvim-treesitter/nvim-treesitter-context',
        config = function()
            require 'treesitter-context'.setup {}
        end
    }
    use {
        'abecodes/tabout.nvim',
        config = function()
            require('tabout').setup {}
        end,
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
    use 'lukas-reineke/indent-blankline.nvim'

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
    use 'folke/tokyonight.nvim'
    use 'projekt0n/github-nvim-theme'
    use { 'stevearc/dressing.nvim' }

    if packer_bootstrap then
        require('packer').sync()
    end
end)
