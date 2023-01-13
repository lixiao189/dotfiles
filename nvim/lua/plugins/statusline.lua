vim.o.showmode = false

require('lualine').setup {
    options = {
        theme = 'dracula-nvim',
        disabled_filetypes = { 'NvimTree', 'Outline' },
        section_separators = '',
        component_separators = ''
    },
}
