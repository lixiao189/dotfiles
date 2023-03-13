return {
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            'folke/neodev.nvim',
            'L3MON4D3/LuaSnip',         -- Snippets plugin
            'saadparwaiz1/cmp_luasnip', -- Snippets source for nvim-cmp
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-buffer',
            'onsails/lspkind-nvim',
            'hrsh7th/cmp-cmdline',
            'hrsh7th/cmp-path',
            'davidsierradz/cmp-conventionalcommits',
            {
                'zbirenbaum/copilot.lua',
                cmd = "Copilot",
                event = "InsertEnter",
                config = function()
                    require("copilot").setup {
                        suggestion = { enabled = false },
                        panel = { enabled = false },
                    }
                end,
            },
            {
                "zbirenbaum/copilot-cmp",
                after = { "copilot.lua" },
                config = function()
                    require("copilot_cmp").setup {
                        method = "getCompletionsCycling",
                    }
                end
            },
        },
        config = function()
            -- nvim-cmp setup
            local luasnip = require 'luasnip'
            local cmp = require 'cmp'

            cmp.setup {
                formatting = {
                    format = require("lspkind").cmp_format({
                        mode = 'symbol', -- show only symbol annotations
                        maxwidth = 50,   -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
                        symbol_map = { Copilot = "" },
                        before = function(_, vim_item)
                            return vim_item
                        end
                    })
                },
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    ['<CR>'] = cmp.mapping.confirm {
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = true,
                    },
                    ['<Tab>'] = cmp.mapping(function(fallback)
                        if luasnip.expand_or_locally_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                    ['<S-Tab>'] = cmp.mapping(function(fallback)
                        if luasnip.locally_jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                }),
                sources = {
                    -- Copilot Source
                    { name = "copilot" },
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
