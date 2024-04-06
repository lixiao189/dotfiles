return {
    "hrsh7th/nvim-cmp",
    dependencies = {
        "VonHeikemen/lsp-zero.nvim",

        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",

        "L3MON4D3/LuaSnip",

        "onsails/lspkind.nvim",
    },
    event = "LspAttach",
    config = function()
        local lsp_zero = require("lsp-zero")
        local cmp = require("cmp")
        local luasnip = require("luasnip")
        local neotab = require("neotab")
        local cmp_action = lsp_zero.cmp_action()

        -- Add sources in cmp
        local preferred_sources = {
            { name = "luasnip" },
            { name = "nvim_lsp" },
            { name = "nvim_lua" },
            { name = "path" },
        }
        local function tooBig(bufnr)
            local max_filesize = 10 * 1024 -- 100 KB
            local check_stats = (vim.uv or vim.loop).fs_stat
            local ok, stats = pcall(check_stats, vim.api.nvim_buf_get_name(bufnr))
            if ok and stats and stats.size > max_filesize then
                return true
            else
                return false
            end
        end
        vim.api.nvim_create_autocmd("BufRead", {
            group = vim.api.nvim_create_augroup("CmpBufferDisableGrp",
                { clear = true }),
            callback = function(ev)
                local sources = preferred_sources
                if not tooBig(ev.buf) then
                    sources[#sources + 1] = { name = "buffer", keyword_length = 4 }
                end
                cmp.setup.buffer({
                    sources = cmp.config.sources(sources),
                })
            end,
        })

        cmp.setup({
            preselect = "item",
            -- Improve the performance
            performance = {
                max_view_entries = 10,
                debounce = 5,
                throttle = 5,
            },
            completion = {
                completeopt = "menu,menuone,noinsert",
            },
            mapping = {
                -- confirm completion item
                ["<Enter>"] = cmp.mapping.confirm({ select = true }),

                -- scroll up and down the documentation window
                ["<C-u>"] = cmp.mapping.scroll_docs(-4),
                ["<C-d>"] = cmp.mapping.scroll_docs(4),

                -- Super tab
                ["<Tab>"] = cmp.mapping(function()
                    if cmp.visible() then
                        cmp.select_next_item()
                    elseif luasnip.expand_or_locally_jumpable() then
                        luasnip.expand_or_jump()
                    else
                        neotab.tabout()
                    end
                end),
                ["<S-Tab>"] = cmp_action.luasnip_shift_supertab(),
            },
            formatting = {
                fields = { 'kind', 'abbr', 'menu' },
                format = require('lspkind').cmp_format({
                    mode = 'symbol',
                    maxwidth = 50,
                    ellipsis_char = '...',
                }),
                expandable_indicator = true,
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
    end
}
