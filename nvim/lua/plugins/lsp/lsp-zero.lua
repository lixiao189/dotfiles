return {
    {
        "VonHeikemen/lsp-zero.nvim",
        branch = "v3.x",
        dependencies = {
            "neovim/nvim-lspconfig",

            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/nvim-cmp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",

            "L3MON4D3/LuaSnip",
            "rafamadriz/friendly-snippets",

            "onsails/lspkind.nvim",

            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
        },
        config = function()
            local lsp_zero = require("lsp-zero")
            lsp_zero.on_attach(function(_, _)
                vim.keymap.set(
                    "n",
                    "<leader>lgd",
                    "<cmd>lua vim.lsp.buf.definition()<cr>",
                    { noremap = true, silent = true, desc = "Go to definition" }
                )
                vim.keymap.set(
                    "n",
                    "<leader>lgD",
                    "<cmd>lua vim.lsp.buf.declaration()<cr>",
                    { noremap = true, silent = true, desc = "Go to declaration" }
                )
                vim.keymap.set(
                    "n",
                    "<leader>lgi",
                    "<cmd>lua vim.lsp.buf.implementation()<cr>",
                    { noremap = true, silent = true, desc = "Go to implementation" }
                )
                vim.keymap.set(
                    "n",
                    "<leader>lgo",
                    "<cmd>lua vim.lsp.buf.type_definition()<cr>",
                    { noremap = true, silent = true, desc = "Go to type definition" }
                )
                vim.keymap.set(
                    "n",
                    "<leader>lgr",
                    "<cmd>Telescope lsp_references<cr>",
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

            local cmp = require("cmp")
            local cmp_action = lsp_zero.cmp_action()

            -- Load snippets
            require("luasnip.loaders.from_vscode").lazy_load()

            cmp.setup({
                preselect = "item",
                performance = {
                    max_view_entries = 10
                },
                completion = {
                    completeopt = "menu,menuone,noinsert",
                },
                sources = {
                    { name = "path" },
                    { name = "nvim_lsp" },
                    { name = "luasnip", keyword_length = 2 },
                    { name = "buffer",  keyword_length = 3 },
                },
                mapping = {
                    -- confirm completion item
                    ["<Enter>"] = cmp.mapping.confirm({ select = true }),

                    -- scroll up and down the documentation window
                    ["<C-u>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-d>"] = cmp.mapping.scroll_docs(4),

                    -- Super tab
                    ["<Tab>"] = cmp_action.luasnip_supertab(),
                    ["<S-Tab>"] = cmp_action.luasnip_shift_supertab(),
                },
                formatting = {
                    fields = { 'kind', 'abbr', 'menu' },
                    format = require('lspkind').cmp_format({
                        mode = 'symbol',
                        maxwidth = 50,
                        ellipsis_char = '...',
                    })
                },
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },
            })

            -- Auto pairs integration
            local cmp_autopairs = require("nvim-autopairs.completion.cmp")
            cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
        end,
    },
}
