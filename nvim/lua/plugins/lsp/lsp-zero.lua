return {
    {
        "VonHeikemen/lsp-zero.nvim",
        branch = "v3.x",
        dependencies = {
            "neovim/nvim-lspconfig",

            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",

            {
                'stevearc/dressing.nvim',
                event = "VeryLazy",
                opts = {},
            }
        },
        event = {
            "BufReadPre",
            "BufNewFile",
        },
        config = function()
            local lsp_zero = require("lsp-zero")
            lsp_zero.on_attach(function(_, _)
                -- Goto
                vim.keymap.set(
                    "n",
                    "gd",
                    "<cmd>lua vim.lsp.buf.definition()<cr>",
                    { noremap = true, silent = true, desc = "Go to definition" }
                )
                vim.keymap.set(
                    "n",
                    "gD",
                    "<cmd>lua vim.lsp.buf.declaration()<cr>",
                    { noremap = true, silent = true, desc = "Go to declaration" }
                )
                vim.keymap.set(
                    "n",
                    "gi",
                    "<cmd>lua vim.lsp.buf.implementation()<cr>",
                    { noremap = true, silent = true, desc = "Go to implementation" }
                )
                vim.keymap.set(
                    "n",
                    "gr",
                    "<cmd>lua vim.lsp.buf.references()<cr>",
                    { noremap = true, silent = true, desc = "Go to references" }
                )

                vim.keymap.set(
                    "n",
                    "<leader>ln",
                    "<cmd>lua vim.lsp.buf.rename()<cr>",
                    { noremap = true, silent = true, desc = "Rename" }
                )

                vim.keymap.set(
                    "n",
                    "<leader>la",
                    "<cmd>lua vim.lsp.buf.code_action()<cr>",
                    { noremap = true, silent = true, desc = "Code action" }
                )

                vim.keymap.set(
                    "n",
                    "K",
                    "<cmd>lua vim.lsp.buf.hover()<cr>",
                    { noremap = true, silent = true, desc = "Hover" }
                )

                vim.keymap.set(
                    "n",
                    "[d",
                    "<cmd>lua vim.diagnostic.goto_prev()<cr>",
                    { noremap = true, silent = true, desc = "Previous diagnostic" }
                )
                vim.keymap.set(
                    "n",
                    "]d",
                    "<cmd>lua vim.diagnostic.goto_next()<cr>",
                    { noremap = true, silent = true, desc = "Next diagnostic" }
                )
                vim.keymap.set('n', 'D', vim.diagnostic.open_float)

                -- List
                vim.keymap.set(
                    "n",
                    "<leader>ld",
                    "<cmd>Telescope diagnostics<cr>",
                    { noremap = true, silent = true, desc = "List diagnostics" }
                )
                vim.keymap.set(
                    "n",
                    "<leader>lo",
                    "<cmd>Telescope lsp_document_symbols<cr>",
                    { noremap = true, silent = true, desc = "List document symbols" }
                )
                vim.keymap.set(
                    "n",
                    "<leader>lO",
                    "<cmd>Telescope lsp_workspace_symbols<cr>",
                    { noremap = true, silent = true, desc = "List workspace symbols" }
                )
            end)

            lsp_zero.set_sign_icons({
                error = "✘",
                warn = "▲",
                hint = "⚑",
                info = "»",
            })

            -- Turn off diagnostic virtual text
            vim.diagnostic.config { virtual_text = false }

            require("mason-lspconfig").setup({
                automatic_installation = true,
                handlers = {
                    lsp_zero.default_setup,
                    -- Fix clangd lsp offset encoding error
                    clangd = function()
                        require("lspconfig").clangd.setup {
                            capabilities = { offsetEncoding = { "utf-16" } }
                        }
                    end,
                    volar = function()
                        require("lspconfig").volar.setup {
                            init_options = {
                                vue = {
                                    hybridMode = false,
                                },
                            },
                        }
                    end
                },
            })
        end,
    },
}
