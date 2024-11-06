return {
  {
    'oxfist/night-owl.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      -- load the colorscheme here
      require("night-owl").setup()
      vim.cmd.colorscheme("night-owl")
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
        icons_enabled = true,
        section_separators = '',
        component_separators = '', -- Disable the separator
        disabled_filetypes = {
          statusline = { "NvimTree", "help", "alpha", "toggleterm" },
        },
        refresh = {
          statusline = 200,
        }
      },
    }
  },
}
