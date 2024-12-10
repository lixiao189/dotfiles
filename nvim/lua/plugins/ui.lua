return {
  {
    "zenbones-theme/zenbones.nvim",
    dependencies = "rktjmp/lush.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      -- vim.opt.guicursor = "n-v-i-c:block-Cursor"
      vim.opt.background = "light"
      vim.cmd("colorscheme zenwritten")
    end
  },

  -- lazy.nvim
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    config = function()
      require("noice").setup({
        lsp = {
          -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
          },
        },
        -- you can enable a preset for easier configuration
        presets = {
          bottom_search = true,   -- use a classic bottom cmdline for search
          command_palette = true, -- position the cmdline and popupmenu together
          long_message_to_split = true, -- long messages will be sent to a split
          inc_rename = false,     -- enables an input dialog for inc-rename.nvim
          lsp_doc_border = false, -- add a border to hover docs and signature help
        },
      })
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
