vim.o.showmode = false

require('lualine').setup {
    options = {
        theme = 'catppuccin',
        disabled_filetypes = { 'neo-tree', 'lspsagaoutline', 'qf' },
        section_separators = '',
        component_separators = ''
    },
}
