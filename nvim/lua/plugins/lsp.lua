return {
    "neoclide/coc.nvim",
    branch = "release",
    dependencies = { "rcarriga/nvim-notify" },
    config = function()
        vim.g.coc_global_extensions = { 'coc-marketplace', 'coc-snippets', 'coc-sumneko-lua' }

        -- Autocomplete
        function _G.check_back_space()
            local col = vim.fn.col('.') - 1
            return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
        end

        local npairs = require('nvim-autopairs')
        _G.MUtils = {}
        MUtils.completion_confirm = function()
            if vim.fn["coc#pum#visible"]() ~= 0 then
                return vim.fn["coc#pum#confirm"]()
            else
                return npairs.autopairs_cr()
            end
        end

        local keyset = vim.keymap.set
        local opts = { silent = true, noremap = true, expr = true, replace_keycodes = false }
        keyset("i", "<TAB>", 'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()',
            opts)
        keyset("i", "<S-TAB>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], opts)
        keyset('i', '<CR>', 'v:lua.MUtils.completion_confirm()', opts)
        keyset("i", "<c-j>", "<Plug>(coc-snippets-expand-jump)")

        keyset("n", "[g", "<Plug>(coc-diagnostic-prev)", { silent = true, desc = "Previous diagnostic" })
        keyset("n", "]g", "<Plug>(coc-diagnostic-next)", { silent = true, desc = "Next diagnostic" })

        keyset("n", "<leader>ln", "<Plug>(coc-rename)", { silent = true, desc = "rename" })

        -- Use K to show documentation in preview window
        function _G.show_docs()
            local cw = vim.fn.expand('<cword>')
            if vim.fn.index({ 'vim', 'help' }, vim.bo.filetype) >= 0 then
                vim.api.nvim_command('h ' .. cw)
            elseif vim.api.nvim_eval('coc#rpc#ready()') then
                vim.fn.CocActionAsync('doHover')
            else
                vim.api.nvim_command('!' .. vim.o.keywordprg .. ' ' .. cw)
            end
        end

        keyset("n", "K", '<CMD>lua _G.show_docs()<CR>', { silent = true })

        -- Remap keys for apply code actions at the cursor position.
        keyset("n", "<leader>la", "<Plug>(coc-codeaction-cursor)", { silent = true, nowait = true, desc = "action" })

        -- Add `:Format` command to format current buffer
        vim.api.nvim_create_user_command("Format", "call CocAction('format')", {})
        keyset("n", "<leader>lf", "<cmd>Format<cr>", { silent = true, desc = "format" })

        -- GoTo code navigation
        keyset("n", "gd", "<Plug>(coc-definition)", { silent = true, desc = "definition" })
        keyset("n", "gD", "<Plug>(coc-type-definition)", { silent = true, desc = "type definition" })
        keyset("n", "gi", "<Plug>(coc-implementation)", { silent = true, desc = "implementation" })
        keyset("n", "gr", "<Plug>(coc-references)", { silent = true, desc = "reference" })

        -- Coc List
        keyset("n", "<leader>lld", ":<C-u>CocList diagnostics<cr>", { silent = true, nowait = true, desc = "diagnostic" })
        keyset("n", "<leader>llo", ":<C-u>CocList outline<cr>", { silent = true, nowait = true, desc = "outline" })
        keyset("n", "<leader>lls", ":<C-u>CocList -I symbols<cr>", { silent = true, nowait = true, desc = "symbols" })

        opts = { silent = true, nowait = true, expr = true }
        keyset("n", "<C-f>", 'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"', opts)
        keyset("n", "<C-b>", 'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"', opts)
        keyset("i", "<C-f>",
            'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(1)<cr>" : "<Right>"', opts)
        keyset("i", "<C-b>",
            'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(0)<cr>" : "<Left>"', opts)
        keyset("v", "<C-f>", 'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"', opts)
        keyset("v", "<C-b>", 'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"', opts)

        -- Highlight the symbol and its references on a CursorHold event(cursor is idle)
        vim.api.nvim_create_augroup("CocGroup", {})

        -- Update signature help on jump placeholder
        vim.api.nvim_create_autocmd("User", {
            group = "CocGroup",
            pattern = "CocJumpPlaceholder",
            command = "call CocActionAsync('showSignatureHelp')",
            desc = "Update signature help on jump placeholder"
        })
    end
}
