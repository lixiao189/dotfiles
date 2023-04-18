return {
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            'folke/neodev.nvim',

            -- Snip
            'dcampos/cmp-snippy',
            {
                'dcampos/nvim-snippy',
                keys = {
                    { '<Tab>', mode = { 'i', 'x' } },
                    'g<Tab>',
                },
                ft = 'snippets',
                cmd = { 'SnippyEdit', 'SnippyReload' },
            },

            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-buffer',
            'onsails/lspkind-nvim',
            'hrsh7th/cmp-cmdline',
            'hrsh7th/cmp-path',
            'davidsierradz/cmp-conventionalcommits',
        },
        config = function()
            -- nvim-cmp setup
            local snippy = require("snippy")
            local cmp = require 'cmp'

            cmp.setup {
                snippet = {
                    -- REQUIRED - you must specify a snippet engine
                    expand = function(args)
                        snippy.expand_snippet(args.body) -- For `snippy` users.
                    end,
                },
                formatting = {
                    format = require("lspkind").cmp_format({
                        mode = 'symbol', -- show only symbol annotations
                        maxwidth = 50,   -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
                        before = function(_, vim_item)
                            return vim_item
                        end
                    })
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    ['<CR>'] = cmp.mapping.confirm {
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = true,
                    },
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if snippy.can_expand_or_advance() then
                            snippy.expand_or_advance()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if snippy.can_jump(-1) then
                            snippy.previous()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                }),
                sources = {
                    { name = 'nvim_lsp' },
                    { name = 'buffer' },
                    { name = 'path' },
                },
            }

            require 'cmp'.setup.buffer {
                sources = require 'cmp'.config.sources(
                    { { name = 'conventionalcommits' } },
                    { { name = 'buffer' } }
                ),
            }

            -- The settings of the cmdline complete
            require 'cmp'.setup.cmdline(':', {
                view = {
                    entries = "custom",
                },
                sources = {
                    { name = 'cmdline' },
                },
                mapping = cmp.mapping.preset.cmdline({}),
            })

            require 'cmp'.setup.cmdline('/', {
                view = {
                    entries = "custom",
                },
                sources = {
                    { name = 'buffer' }
                },
                mapping = cmp.mapping.preset.cmdline({}),
            })
        end
    },

    {
        'Shatur/neovim-cmake',
        dependencies = { "mfussenegger/nvim-dap" },
        config = function()
            require('cmake').setup {
            }
        end
    },
    {
        'folke/trouble.nvim',
        config = function()
            require('trouble').setup()
        end
    },
    {
        "glepnir/lspsaga.nvim",
        branch = "main",
        config = function()
            require('lspsaga').setup {
                lightbulb = {
                    sign = false,
                },
                symbol_in_winbar = {
                    show_file = false,
                },
            }
        end,
    },
}
