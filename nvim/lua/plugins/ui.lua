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

  {
    "echasnovski/mini.indentscope",
    version = false, -- wait till new 0.7.0 release to put it back on semver
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      -- symbol = "▏",
      symbol = "│",
      options = { try_as_border = true },
    },
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "alpha",
          "dashboard",
          "fzf",
          "help",
          "lazy",
          "lazyterm",
          "mason",
          "neo-tree",
          "notify",
          "toggleterm",
          "Trouble",
          "trouble",
        },
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
    end,
  },
}
