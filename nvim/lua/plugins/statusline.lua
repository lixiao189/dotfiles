vim.o.showmode = false

require('lualine').setup {
    options = {
        theme = 'catppuccin',
        disabled_filetypes = { 'neo-tree', 'lspsagaoutline', 'qf', 'alpha' },
        section_separators = '',
        component_separators = ''
    },
}
