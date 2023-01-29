vim.o.completeopt = "menu,menuone,noselect"

-- nvim-cmp setup
local luasnip = require 'luasnip'
local cmp = require 'cmp'

cmp.setup {
    formatting = {
        format = require("lspkind").cmp_format({
            mode = 'symbol_text', -- show only symbol annotations
            maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
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
        { name = 'nvim_lsp' },
        { name = 'buffer' },
    },
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