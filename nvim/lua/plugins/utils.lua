---@diagnostic disable: unused-local, undefined-field
return {
  {
    "HakonHarnes/img-clip.nvim",
    event = "VeryLazy",
    opts = {
      -- add options here
      -- or leave it empty to use the default settings
    },
    keys = {
      -- suggested keymap
      { "<leader>p", "<cmd>PasteImage<cr>", desc = "Paste image" },
    },
  },

  -- Async run
  {
    "skywind3000/asyncrun.vim",
    cmd = { "AsyncRun", "AsyncStop", "AsyncReset" },
    init = function()
      vim.g.asyncrun_open = 10
    end,
    keys = {
      -- suggested keymap
      { "<leader>r", ":AsyncRun ", desc = "Async run command" },
    },
  },

  {
    "folke/flash.nvim",
    optional = true,
    keys = {
      -- Simulate nvim-treesitter incremental selection
      {
        "<enter>",
        mode = { "n", "o", "x" },
        function()
          require("flash").treesitter({
            actions = {
              ["<enter>"] = "next",
              ["<BS>"] = "prev",
            },
          })
        end,
        desc = "Treesitter Incremental Selection",
      },
    },
  },
  {
    "folke/snacks.nvim",
    optional = true,
    opts = {
      words = {
        enabled = false,
      },
    },
  },
}
