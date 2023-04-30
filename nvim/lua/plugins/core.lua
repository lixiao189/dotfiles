return {
  'famiu/bufdelete.nvim',
  'nvim-lua/plenary.nvim',
  'danilamihailov/beacon.nvim',

  {
    'abecodes/tabout.nvim',
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require('tabout').setup {}
    end
  },

  {
    'phaazon/hop.nvim',
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require 'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }
    end
  },

  {
    "aserowy/tmux.nvim",
    event = "VimEnter",
    config = function() return require("tmux").setup() end
  },

  {
    'karb94/neoscroll.nvim',
    event = "VimEnter",
    config = true
  },

  -- The search and replace plugin
  {
    'windwp/nvim-spectre',
    event = "VeryLazy",
    config = true
  },

  -- Lsp colorized
  {
    'norcalli/nvim-colorizer.lua',
    event = "VeryLazy",
    config = function()
      require 'colorizer'.setup()
    end
  },

  -- The markdown previewer with web browser
  {
    "iamcco/markdown-preview.nvim",
    event = "VeryLazy",
    build = function() vim.fn["mkdp#util#install"]() end,
  },

  -- The telescope support
  {
    'nvim-telescope/telescope.nvim',
    event = "VimEnter"
  },

  -- Auto pairs
  {
    'windwp/nvim-autopairs',
    event = { "InsertEnter" },
    config = function()
      require('nvim-autopairs').setup()
    end
  },

  -- The file manager
  {
    "nvim-neo-tree/neo-tree.nvim",
    event = "VimEnter",
    branch = "v2.x",
    dependencies = {
      'nvim-tree/nvim-web-devicons', -- for file icons
      "MunifTanjim/nui.nvim",
      { 's1n7ax/nvim-window-picker', version = "v1.*" }
    }
  },

  -- The commenter
  {
    'numToStr/Comment.nvim',
    event = "InsertEnter",
    config = function()
      require('Comment').setup {
        pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
      }
    end
  },

  -- The plugin to solve cutting problem
  {
    'gbprod/cutlass.nvim',
    event = { "VimEnter" },
    config = function()
      require("cutlass").setup {
        cut_key = 'x',
        override_del = 'd',
      }
    end
  },
}
