return {
    {
        "VonHeikemen/lsp-zero.nvim",
        branch = "v3.x",
        dependencies = {
            "neovim/nvim-lspconfig",

            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",

            {
                "nvimdev/lspsaga.nvim",
                event = "LspAttach",
                dependencies = {
                    "nvim-treesitter/nvim-treesitter",
                    "nvim-tree/nvim-web-devicons"
                },
                opts = {
                    lightbulb = { virtual_text = false },
                    beacon = { enable = true },
                    ui = { code_action = "" },
                    code_action = { keys = { quit = "<esc>" }, num_shortcut = false },
                    rename = { keys = { quit = "<esc>" } }
                }
            }
        },
        config = function()
            local lsp_zero = require("lsp-zero")
            lsp_zero.on_attach(function(_, _)
                vim.keymap.set(
                    "n",
                    "<leader>lgd",
                    "<cmd>Lspsaga peek_definition<cr>",
                    { noremap = true, silent = true, desc = "Go to definition" }
                )
                vim.keymap.set(
                    "n",
                    "<leader>lgi",
                    "<cmd>Lspsaga finder imp<cr>",
                    { noremap = true, silent = true, desc = "Go to implementation" }
                )
                vim.keymap.set(
                    "n",
                    "<leader>lgt",
                    "<cmd>Lspsaga peek_type_definition<cr>",
                    { noremap = true, silent = true, desc = "Go to type definition" }
                )
                vim.keymap.set(
                    "n",
                    "<leader>lgr",
                    "<cmd>Lspsaga finder ref<cr>",
                    { noremap = true, silent = true, desc = "Go to references" }
                )
                vim.keymap.set(
                    "n",
                    "<leader>lgs",
                    "<cmd>lua vim.lsp.buf.signature_help()<cr>",
                    { noremap = true, silent = true, desc = "Show signature help" }
                )
                vim.keymap.set(
                    "n",
                    "<leader>ln",
                    "<cmd>Lspsaga rename<cr>",
                    { noremap = true, silent = true, desc = "Rename" }
                )
                vim.keymap.set(
                    "n",
                    "<leader>la",
                    "<cmd>Lspsaga code_action<cr>",
                    { noremap = true, silent = true, desc = "Code action" }
                )
                vim.keymap.set(
                    "n",
                    "<leader>lo",
                    "<cmd>Lspsaga outline<cr>",
                    { noremap = true, silent = true, desc = "Toggle outline" }
                )

                vim.keymap.set(
                    "n",
                    "K",
                    "<cmd>Lspsaga hover_doc<cr>",
                    { noremap = true, silent = true, desc = "Hover" }
                )
                vim.keymap.set(
                    "n",
                    "[d",
                    "<cmd>Lspsaga diagnostic_jump_prev<cr>",
                    { noremap = true, silent = true, desc = "Previous diagnostic" }
                )
                vim.keymap.set(
                    "n",
                    "]d",
                    "<cmd>Lspsaga diagnostic_jump_next<cr>",
                    { noremap = true, silent = true, desc = "Next diagnostic" }
                )
                vim.keymap.set('n', 'D', vim.diagnostic.open_float)

                -- List
                vim.keymap.set(
                    "n",
                    "<leader>lld",
                    "<cmd>Telescope diagnostics<cr>",
                    { noremap = true, silent = true, desc = "List diagnostics" }
                )
                vim.keymap.set(
                    "n",
                    "<leader>llo",
                    "<cmd>Telescope lsp_document_symbols<cr>",
                    { noremap = true, silent = true, desc = "List symbols" }
                )
                vim.keymap.set(
                    "n",
                    "<leader>llO",
                    "<cmd>Telescope lsp_workspace_symbols<cr>",
                    { noremap = true, silent = true, desc = "List symbols" }
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
                    end
                },
            })
        end,
    },
}
