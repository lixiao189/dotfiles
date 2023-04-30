return {
  {
    'j-hui/fidget.nvim',
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { 'neovim/nvim-lspconfig' },
    config = function()
      require "fidget".setup {
        window = {
          blend = 0,
        },
      }
    end
  },

  {
    'folke/trouble.nvim',
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { 'neovim/nvim-lspconfig' },
    config = true
  },

  {
    'Shatur/neovim-cmake',
    event = "VeryLazy",
    dependencies = { "mfussenegger/nvim-dap" },
    config = true
  },


  {
    "glepnir/lspsaga.nvim",
    event = { "BufReadPre", "BufNewFile" },
    branch = "main",
    dependencies = { 'neovim/nvim-lspconfig' },
    config = function()
      require('lspsaga').setup {
        lightbulb = {
          sign = false,
        },
      }
    end,
  },

  {
    'neovim/nvim-lspconfig',
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "folke/neoconf.nvim", cmd = "Neoconf",                                config = true },
      "mason.nvim",
      { "folke/neodev.nvim",  opts = { experimental = { pathStrict = true } } },
      "williamboman/mason-lspconfig.nvim",

    }
  },

  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end
  },
  {
    'williamboman/mason-lspconfig.nvim',
    config = function()
      local servers = {
        'clangd',
        'neocmake',
        'lua_ls',
      }
      require("mason-lspconfig").setup {
        ensure_installed = servers,
      }

      require("neodev").setup {}       -- make sure to setup lua-dev BEFORE lspconfig
      require("mason-lspconfig").setup_handlers {
        function(server_name)          -- default handler
          local capabilities = require('cmp_nvim_lsp').default_capabilities()
          local lsp_server = require("lspconfig")[server_name]

          if lsp_server == nil then
            return
          elseif server_name == "lua_ls" then
            lsp_server.setup {
              capabilities = capabilities,
              settings = { Lua = { completion = { callSnippet = "Replace" } } } }
          elseif server_name == "clangd" then
            capabilities.offsetEncoding = { "utf-16" }
            lsp_server.setup { capabilities = capabilities }
          else
            lsp_server.setup { capabilities = capabilities }
          end
        end,
      }
    end
  },

  {
    'jayp0521/mason-null-ls.nvim',
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      'jose-elias-alvarez/null-ls.nvim',
    },
    config = function()
      -- auto install formater
      require("mason-null-ls").setup({
        ensure_installed = {
          -- Opt to list sources here, when available in mason.
          'autopep8',
          'prettier'
        },
        automatic_installation = true,
        handlers = {}
      })
      require("null-ls").setup()
    end
  },
}
