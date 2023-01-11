vim.o.termguicolors = true

require("bufferline").setup {
    options = {
        close_command = "Bdelete! %d", -- can be a string | function, see "Mouse actions"
        right_mouse_command = "Bdelete! %d", -- can be a string | function, see "Mouse actions"
        diagnostics_update_in_insert = true,
        diagnostics = "nvim_lsp",
        numbers = function(opts)
            return string.format('%s', opts.ordinal)
        end,
    }
}
