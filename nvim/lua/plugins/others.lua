return {
  "mg979/vim-visual-multi",

  {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false }
  },

  {
    "echasnovski/mini.pairs",
    event = "VeryLazy",
    opts = {
      modes = { insert = true, command = true, terminal = false },
      -- skip autopair when next character is one of these
      skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
      -- skip autopair when the cursor is inside these treesitter nodes
      skip_ts = { "string" },
      -- skip autopair when next character is closing pair
      -- and there are more closing pairs than opening pairs
      skip_unbalanced = true,
      -- better deal with markdown code blocks
      markdown = true,
    },
  },

  {
    'windwp/nvim-ts-autotag',
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require('nvim-ts-autotag').setup()
    end
  },

  {
    "rbgrouleff/bclose.vim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      vim.keymap.set("n", "<leader>d", "<CMD>Bclose<CR>",
        { silent = true, noremap = true })
    end
  },

  {
    "Asheq/close-buffers.vim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      vim.keymap.set("n", "Q", "<CMD>Bdelete menu<CR>", { silent = true, noremap = true })
    end
  },

  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    event = "VeryLazy",
    dependencies = {
      "nvim-tree/nvim-web-devicons"
    },
    config = function()
      require("nvim-tree").setup {
        renderer = {
          group_empty = true,
        }
      }
      vim.keymap.set("n", "<leader>e", "<CMD>NvimTreeToggle<CR>",
        { silent = true, noremap = true, desc = "Explorer NeoTree (root dir)" })
      vim.keymap.set("n", "<leader>E", "<CMD>NvimTreeFindFileToggle<CR>",
        { silent = true, noremap = true, desc = "Explorer NeoTree (cwd)" })
    end,
  },

  {
    'numToStr/Comment.nvim',
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      'JoosepAlviste/nvim-ts-context-commentstring',
      config = function()
        require('ts_context_commentstring').setup {
          enable_autocmd = false,
        }
      end
    },
    config = function()
      require('Comment').setup {
        pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
      }
    end
  },

  {
    "kylechui/nvim-surround",
    event = { "BufReadPre", "BufNewFile" },
    version = "*",
    config = true,
  },
}
