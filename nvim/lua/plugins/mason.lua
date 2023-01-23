require("mason").setup()

local augroup_format = vim.api.nvim_create_augroup("Format", { clear = true })
local attach_func = function(_, bufnr)
    -- Show diagnostic under cursor
    vim.api.nvim_create_autocmd("CursorHold", {
        buffer = bufnr,
        callback = function()
            local opts = {
                focusable = false,
                close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
                source = 'always',
                prefix = ' ',
                scope = 'cursor',
            }
            vim.diagnostic.open_float(nil, opts)
        end
    })

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
    'sumneko_lua',
}
require("mason-lspconfig").setup {
    ensure_installed = servers,
}

local capabilities = require('cmp_nvim_lsp').default_capabilities()
require("neodev").setup {} -- make sure to setup lua-dev BEFORE lspconfig
require("mason-lspconfig").setup_handlers {
    function(server_name) -- default handler
        require("lspconfig")[server_name].setup {
            capabilities = capabilities,
            on_attach = attach_func
        }
    end,

    ["sumneko_lua"] = function()
        require("lspconfig")["sumneko_lua"].setup {
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
    end
}

-- auto install formater
require("mason-null-ls").setup({
    ensure_installed = {
        -- Opt to list sources here, when available in mason.
        'autopep8',
        'prettier'
    },
    automatic_installation = true,
    automatic_setup = false, -- Recommended, but optional
})

-- set formater
local null_ls = require("null-ls")
require("null-ls").setup {
    sources = {
        null_ls.builtins.formatting.prettier,
        null_ls.builtins.formatting.autopep8
    }
}
