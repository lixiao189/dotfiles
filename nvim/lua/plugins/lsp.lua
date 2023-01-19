function CopyTable(tab)
    local function _copy(obj)
        if type(obj) ~= "table" then
            return obj
        end
        local new_table = {}
        for k, v in pairs(obj) do
            new_table[_copy(k)] = _copy(v)
        end
        return setmetatable(new_table, getmetatable(obj))
    end

    return _copy(tab)
end

local augroup_format = vim.api.nvim_create_augroup("Format", { clear = true })
local enable_format_on_save = function(_, bufnr)
    vim.api.nvim_clear_autocmds({ group = augroup_format, buffer = bufnr })
    vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup_format,
        buffer = bufnr,
        callback = function()
            vim.lsp.buf.format({ bufnr = bufnr })
        end,
    })
end

vim.o.completeopt = "menu,menuone,noselect"

-- Lsp signature settings
require("lsp_signature").setup {
    bind = true, -- This is mandatory, otherwise border config won't get registered.
    hint_enable = false,
}

-- Lsp server list
local servers = {
    'pyright',
    'tsserver',
    'gopls',
    'clangd',
    'neocmake',
    'volar',
    'jdtls',
    'jsonls',
    'yamlls',
    'rust_analyzer',
    'vimls',
    'omnisharp_mono',
    'sumneko_lua',
    'intelephense',
}
require("mason-lspconfig").setup({
    ensure_installed = servers,
    automatic_installation = true, -- automatically detect which servers to install (based on which servers are set up via lspconfig)
})

-- nvim-cmp setup
local luasnip = require 'luasnip'
local cmp = require 'cmp'
cmp.setup {
    view = {
        -- entries = "native" -- can be "custom", "wildmenu" or "native"
    },
    formatting = {
        format = require("lspkind").cmp_format({
            mode = 'symbol_text', -- show only symbol annotations
            maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
            before = function(_, vim_item)
                return vim_item
            end
        })
    },
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        },
        ['<Tab>'] = cmp.mapping(function(fallback)
            if luasnip.expand_or_locally_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if luasnip.locally_jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { 'i', 's' }),
    }),
    sources = {
        { name = 'nvim_lsp' },
        { name = 'buffer' },
    },
}

-- The settings of the cmdline complete
require 'cmp'.setup.cmdline(':', {
    view = {
        entries = "custom",
    },
    sources = {
        { name = 'cmdline' },
    },
    mapping = cmp.mapping.preset.cmdline({}),
})
require 'cmp'.setup.cmdline('/', {
    view = {
        entries = "custom",
    },
    sources = {
        { name = 'buffer' }
    },
    mapping = cmp.mapping.preset.cmdline({}),
})

-- The settings of auto completion and lsp setup
-- Add additional capabilities supported by nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

local global_opts = {}
global_opts.capabilities = capabilities
global_opts.on_attach = function(client, bufnr)
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

    enable_format_on_save(client, bufnr)
end


-- IMPORTANT: make sure to setup lua-dev BEFORE lspconfig
require("neodev").setup({})
-- Setup lsp server
for _, server in ipairs(servers) do
    local local_opts = CopyTable(global_opts)
    if (server == "sumneko_lua") then
        local_opts.settings = {
            Lua = {
                completion = {
                    callSnippet = "Replace"
                }
            }
        }
    end

    require('lspconfig')[server].setup(local_opts)
end

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
