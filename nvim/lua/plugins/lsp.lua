return {
  -- Copilot AI
  {
    "zbirenbaum/copilot.lua",
    dependencies = {
      "AndreM222/copilot-lualine",
      {
        "nvim-lualine/lualine.nvim",
        config = function(_, opts)
          opts.sections = {
            lualine_x = { 'copilot', 'encoding', 'fileformat', 'filetype' },
          }
          require("lualine").setup(opts)
        end
      }
    },
    config = function()
      require("copilot").setup {
        suggestion = {
          auto_trigger = true,
        }
      }
    end,
  },


  -- Lsp installer
  {
    "williamboman/mason.nvim",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup {
        ensure_installed = { "lua_ls", "marksman", "pyright", "ruff" }
      }
      require("mason-tool-installer").setup {
        ensure_installed = {
          "prettierd",
        },
      }
    end
  },

  -- Blink Cmp plugin
  {
    'saghen/blink.cmp',
    lazy = false,
    version = 'v0.*',
    config = function()
      -- Keymap for snippet
      local suggestion = require("copilot.suggestion")
      local function is_pair()
        local col = vim.fn.col('.') - 1
        local next_char = vim.fn.getline('.'):sub(col + 1, col + 1)
        return next_char:match("[%)%]}>\"';`]") ~= nil
      end

      require("blink.cmp").setup {
        keymap = {
          preset = 'enter',
          ['<Tab>'] = {
            function(cmp)
              if suggestion.is_visible() then -- Copilot
                return suggestion.accept()
              elseif cmp.snippet_active() then -- Snippet
                return cmp.snippet_forward()
              elseif is_pair() then               -- Tabout
                return vim.api.nvim_input('<Right>')
              end
            end,
            'fallback',
          },
          ['<S-Tab>'] = { 'snippet_backward', 'fallback' },
        },
        completion = {
          trigger = {
            show_on_trigger_character = false
          }
        }
      }
    end
  },

  -- Lsp config
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "saghen/blink.cmp",
      "williamboman/mason-lspconfig.nvim",
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      local cmp = require("blink.cmp")
      local capabilities = cmp.get_lsp_capabilities()
      local on_attach = function(client)
        client.server_capabilities.semanticTokensProvider = nil
      end
      local lspconfig = require("lspconfig")

      require("mason-lspconfig").setup_handlers {
        function(server_name)
          lspconfig[server_name].setup {
            capabilities = capabilities,
            on_attach = on_attach,
          }
        end,
        ["pyright"] = function()
          lspconfig.pyright.setup {
            capabilities = capabilities,
            on_attach = on_attach,
            settings = {
              pyright = {
                -- Using Ruff's import organizer
                disableOrganizeImports = true,
              },
              python = {
                analysis = {
                  ignore = { '*' },
                },
              },
            },
          }
        end
      }

      -- configure Swift serve here since it is not installed via Mason
      lspconfig.sourcekit.setup({
        -- capabilities = capabilities,
        capabilities = cmp.get_lsp_capabilities({
          workspace = {
            didChangeWatchedFiles = {
              dynamicRegistration = true,
            },
          },
        }),
        on_attach = on_attach,
      })

      -- Keymap for lsp
      vim.api.nvim_create_autocmd('LspAttach', {
        desc = 'LSP Actions',
        callback = function(ev)
          local opts = { noremap = true, silent = true, buffer = ev.bufnr }
          local builtin = require('telescope.builtin')

          opts.desc = "Go to declaration"
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
          opts.desc = "Go to definition"
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
          opts.desc = "Go to implementation"
          vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
          opts.desc = "Go to references"
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
          opts.desc = "Lsp rename"
          vim.keymap.set('n', '<space>ln', vim.lsp.buf.rename, opts)
          opts.desc = "Lsp actions"
          vim.keymap.set('n', '<space>la', vim.lsp.buf.code_action, opts)
          opts.desc = "Lsp diagnostics"
          vim.keymap.set('n', '<space>ld', builtin.diagnostics, opts)
          opts.desc = "Lsp document symbols"
          vim.keymap.set('n', '<space>lo', builtin.lsp_document_symbols, opts)
          opts.desc = "Lsp workspace symbols"
          vim.keymap.set('n', '<space>ls', builtin.lsp_workspace_symbols, opts)
        end,
      })

      -- Disable lsp diagnostics signs
      vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
        vim.lsp.diagnostic.on_publish_diagnostics, {
          signs = false
        }
      )
    end
  },

  { "j-hui/fidget.nvim", opts = {} },

  -- Formatter
  {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local conform = require("conform")
      conform.setup {
        formatters_by_ft = {
          markdown = { "prettierd" },
          javascript = { "prettierd" },
          typescript = { "prettierd" },
          javascriptreact = { "prettierd" },
          typescriptreact = { "prettierd" },
          css = { "prettierd" },
          html = { "prettierd" },
          json = { "prettierd" },
          yaml = { "prettierd" },
        },
      }
      vim.keymap.set({ "n", "v" }, "<leader>lf", function()
        conform.format({
          lsp_fallback = true,
          async = true,
          timeout_ms = 1000,
        })
      end, { desc = "Format file or range" })
    end
  },
}
