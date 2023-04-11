return {
    -- Theme: solarized dark theme
    -- {
    --     'svrana/neosolarized.nvim',
    --     dependencies = { 'tjdevries/colorbuddy.nvim' },
    --     opts = {
    --         comment_italics = true,
    --         background_set = false,
    --     },
    -- },

    -- Theme: solarized light theme
    -- {
    --     'shaunsingh/solarized.nvim',
    --     config = function()
    --         vim.o.background = 'light'
    --         vim.g.solarized_borders = true
    --         require('solarized').set()
    --     end
    -- },

    {
        'navarasu/onedark.nvim',
        config = function() 
            require('onedark').load()
        end
    },

    -- Status line plugin
    {
        'nvim-lualine/lualine.nvim',
        opts = {
            options = {
                theme = 'auto',
                disabled_filetypes = { 'neo-tree', 'lspsagaoutline', 'qf', 'alpha', 'dbui' },
                section_separators = '',
                component_separators = ''
            },
            sections = {
                lualine_b = { 'branch', 'diagnostics' },
            },
        },
    },
    {
        'stevearc/dressing.nvim',
        config = function()
            require('dressing').setup()
        end
    }
}
