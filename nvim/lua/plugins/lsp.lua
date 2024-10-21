return {
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
                ensure_installed = { "lua_ls", "pyright", "ruff_lsp" }
            }
            require("mason-tool-installer").setup {
                ensure_installed = {
                    "prettierd"
                },
            }
        end
    },

    -- Cmp plugin
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-nvim-lsp"
        },
        config = function()
            local cmp = require("cmp")

            cmp.setup {
                completion = {
                    completeopt = 'menu,menuone,noinsert'
                },
                mapping = cmp.mapping.preset.insert({
                    ["<CR>"] = cmp.mapping.confirm()
                }),
                sources = cmp.config.sources({
                    { name = 'nvim_lsp' },
                }, {
                    { name = 'buffer' },
                })
            }

            -- Keymap for snippet
            local function is_pair()
                local col = vim.fn.col('.') - 1
                local next_char = vim.fn.getline('.'):sub(col + 1, col + 1)
                return next_char:match("[%)%]}>\"';`]") ~= nil
            end
            vim.keymap.set({ 'i', 's' }, '<Tab>', function()
                if vim.snippet.active({ direction = 1 }) then
                    return '<cmd>lua vim.snippet.jump(1)<cr>'
                elseif is_pair() then -- Tabout
                    vim.api.nvim_input('<Right>')
                else
                    return '<Tab>'
                end
            end, { expr = true })
            vim.keymap.set({ 'i', 's' }, '<S-Tab>', function()
                if vim.snippet.active({ direction = -1 }) then
                    return '<cmd>lua vim.snippet.jump(-1)<cr>'
                end
            end, { expr = true })
        end
    },

    -- Lsp config
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "williamboman/mason-lspconfig.nvim",
            "nvim-telescope/telescope.nvim"
        },
        config = function()
            local capabilities = require('cmp_nvim_lsp').default_capabilities()
            local on_attach = function(client) client.server_capabilities.semanticTokensProvider = nil end
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
                        settings = {
                            pyright = {
                                -- Using Ruff's import organizer
                                disableOrganizeImports = true,
                            },
                            python = {
                                analysis = {
                                    -- Ignore all files for analysis to exclusively use Ruff for linting
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
                capabilities = {
                    workspace = {
                        didChangeWatchedFiles = {
                            dynamicRegistration = true,
                        },
                    },
                },
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
                format_on_save = {
                    lsp_fallback = true,
                    async = false,
                    timeout_ms = 1000,
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
