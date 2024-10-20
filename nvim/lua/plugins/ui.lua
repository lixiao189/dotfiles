return {
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd [[colorscheme tokyonight]]
        end
    },

    -- Dashboard
    {
        'goolord/alpha-nvim',
        config = function()
            local startify = require("alpha.themes.startify")
            startify.file_icons.enabled = false
            require 'alpha'.setup(startify.config)
        end
    },

    -- Statusline
    {
        'nvim-lualine/lualine.nvim',
        event = "VeryLazy",
        opts = {
            options = {
                icons_enabled = false,
                section_separators = '',
                component_separators = '', -- Disable the separator
                disabled_filetypes = {
                    statusline = { "NvimTree", "help", "alpha" },
                },
            },
        }
    },
}
