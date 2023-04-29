return {
  -- Status line plugin
  {
    'nvim-lualine/lualine.nvim',
    event = "VeryLazy",
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
  },


  {
    'nvim-tree/nvim-web-devicons',
    config = true
  },

  -- Notify plugin
  {
    'rcarriga/nvim-notify',
    config = function()
      vim.notify = require("notify")
      require("notify").setup({
        background_colour = "#000000",
      })
      -- Enable telescope support
      require("telescope").load_extension("notify")
    end
  },

  {
    'akinsho/bufferline.nvim',
    event = "VeryLazy",
    opts = {
      options = {
        separator_style = { "", "" },
        always_show_bufferline = false,
        close_command = "Bdelete! %d",    -- can be a string | function, see "Mo actions"
        right_mo_command = "Bdelete! %d", -- can be a string | function, see "Mouse actions"
        diagnostics_update_in_insert = true,
        diagnostics = "nvim_lsp",
        offsets = {
          {
            filetype = "neo-tree",
            text = "Neo-tree",
            highlight = "Directory",
            text_align = "left",
          },
        }
      }
    }
  },

  {
    'goolord/alpha-nvim',
    event = "VimEnter",
    config = function()
      require 'alpha'.setup(require 'alpha.themes.startify'.config)
    end
  },
}
