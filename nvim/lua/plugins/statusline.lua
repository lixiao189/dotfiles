vim.o.showmode = false

require('lualine').setup {
    options = {
        theme = 'github_dark_default',
        disabled_filetypes = { 'NvimTree', 'Outline' },
        section_separators = '',
        component_separators = ''
    },
}
