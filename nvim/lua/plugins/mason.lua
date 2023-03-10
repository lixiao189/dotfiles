return {
    {
        'j-hui/fidget.nvim',
        config = function()
            require "fidget".setup {
                window = {
                    blend = 0,
                },
            }
        end
    },
    'neovim/nvim-lspconfig',
    {
        "folke/neoconf.nvim",
        config = function()
            require("neoconf").setup {}
        end
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
            local augroup_format = vim.api.nvim_create_augroup("Format", { clear = true })
            local attach_func = function(_, bufnr)
                -- auto format after save
                vim.api.nvim_clear_autocmds({ group = augroup_format, buffer = bufnr })
                vim.api.nvim_create_autocmd("BufWritePre", {
                    group = augroup_format,
                    buffer = bufnr,
                    callback = function()
                        vim.lsp.buf.format({ bufnr = bufnr })
                    end,
                })
            end

            local servers = {
                'clangd',
                'neocmake',
                'lua_ls',
            }
            require("mason-lspconfig").setup {
                ensure_installed = servers,
            }

            require("neodev").setup {} -- make sure to setup lua-dev BEFORE lspconfig
            require("mason-lspconfig").setup_handlers {
                function(server_name)  -- default handler
                    local capabilities = require('cmp_nvim_lsp').default_capabilities()
                    local lsp_server = require("lspconfig")[server_name]

                    if lsp_server == nil then
                        return
                    elseif server_name == "lua_ls" then
                        lsp_server.setup {
                            capabilities = capabilities,
                            on_attach = attach_func,
                            settings = {
                                Lua = {
                                    completion = {
                                        callSnippet = "Replace"
                                    }
                                }
                            }
                        }
                    elseif server_name == "clangd" then
                        capabilities.offsetEncoding = { "utf-16" }
                        lsp_server.setup {
                            capabilities = capabilities,
                            on_attach = attach_func
                        }
                    else
                        lsp_server.setup {
                            capabilities = capabilities,
                            on_attach = attach_func
                        }
                    end
                end,
            }
        end
    },
    {
        'jayp0521/mason-null-ls.nvim',
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
            })
            require 'mason-null-ls'.setup_handlers {
                function(source_name, methods)
                    require("mason-null-ls.automatic_setup")(source_name, methods)
                end
            }

            -- set formater
            require("null-ls").setup()
        end
    },
}
