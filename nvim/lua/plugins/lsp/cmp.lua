return {
    "hrsh7th/nvim-cmp",
    dependencies = {
        "VonHeikemen/lsp-zero.nvim",

        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",

        "L3MON4D3/LuaSnip",
    },
    event = "LspAttach",
    config = function()
        local lsp_zero = require("lsp-zero")
        local cmp = require("cmp")
        local cmp_action = lsp_zero.cmp_action()

        -- Add sources in cmp
        cmp.setup({
            preselect = "item",
            -- Improve the performance
            performance = {
                max_view_entries = 10,
                debounce = 5,
                throttle = 5,
            },
            sources = {
                { name = "nvim_lsp" },
                { name = "luasnip" },
                { name = "buffer" },
                { name = "nvim_lua" },
                { name = "path" },
            },
            formatting = {
                fields = {
                    -- cmp.ItemField.Kind,
                    cmp.ItemField.Abbr,
                    cmp.ItemField.Menu,
                },
            },
            mapping = {
                -- confirm completion item
                ["<Enter>"] = cmp.mapping.confirm({ select = true }),

                -- scroll up and down the documentation window
                ["<C-u>"] = cmp.mapping.scroll_docs(-4),
                ["<C-d>"] = cmp.mapping.scroll_docs(4),

                ['<C-e>'] = cmp.mapping.abort(),

                -- Super tab
                ["<Tab>"] = cmp_action.luasnip_supertab(),
                ["<S-Tab>"] = cmp_action.luasnip_shift_supertab(),
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
