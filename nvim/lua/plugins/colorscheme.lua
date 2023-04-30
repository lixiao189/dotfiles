return {
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
    event = "VimEnter",
    config = function()
      require('onedark').load()
    end
  },
}
