return {
    -- IDE-like breadcrumbs
    -- 'Bekaboo/dropbar.nvim',

    -- Lsp installer
    {
        "williamboman/mason.nvim",
        dependencies = {
            "williamboman/mason-lspconfig.nvim",
        },
        config = function()
            require("mason").setup()
            require("mason-lspconfig").setup {
                ensure_installed = { "lua_ls" }
            }
        end
    },

    -- Cmp plugin
    {
        "hrsh7th/nvim-cmp",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = { "windwp/nvim-autopairs" },
        config = function()
            local cmp = require("cmp")
            cmp.setup {
                performance = {
                    max_view_entries = 10,
                    debounce = 5,
                    throttle = 5,
                },
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

            --Settings for nvim autopairs
            local cmp_autopairs = require('nvim-autopairs.completion.cmp')
            cmp.event:on(
                'confirm_done',
                cmp_autopairs.on_confirm_done()
            )

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
            "williamboman/mason-lspconfig.nvim"
        },
        config = function()
            local capabilities = require('cmp_nvim_lsp').default_capabilities()
            require("mason-lspconfig").setup_handlers {
                function(server_name)
                    require("lspconfig")[server_name].setup {
                        capabilities = capabilities,
                    }
                end,
            }

            -- Keymap for lsp
            vim.api.nvim_create_autocmd('LspAttach', {
                desc = 'LSP Actions',
                callback = function(ev)
                    local opts = { noremap = true, silent = true, buffer = ev.bufnr }
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
            conform.setup()
            vim.keymap.set({ "n", "v" }, "<leader>lf", function()
                conform.format({
                    lsp_fallback = true,
                    async = true,
                    timeout_ms = 1000,
                })
            end, { desc = "Format file or range" })
        end
    }
}
