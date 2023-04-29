return {
  {
    'hrsh7th/nvim-cmp',
    event = "InsertEnter",
    dependencies = {
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
        mapping = cmp.mapping.preset.insert({
          ['<C-d>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = false,
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
          { name = 'nvim_lsp', max_item_count = 8 },
          { name = 'buffer' },
        },
      }
    end
  },
}
