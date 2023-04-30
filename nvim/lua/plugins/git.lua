return {
  -- The git tui client
  {
    'TimUntersberger/neogit',
    event = "VeryLazy",
    dependencies = 'nvim-lua/plenary.nvim',
    config = function()
      require('neogit').setup {}
    end
  },
  {
    'akinsho/git-conflict.nvim',
    event = "VeryLazy",
    config = function()
      require('git-conflict').setup()
    end
  },
  -- Show the diff signs of the git
  {
    'lewis6991/gitsigns.nvim',
    event = "VimEnter",
    config = function()
      require('gitsigns').setup {
      }
    end
  },
}
