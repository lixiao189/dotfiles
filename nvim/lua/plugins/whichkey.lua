return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  config = function()
    require("which-key").setup {
      delay = 1000,
      layout = { align = "center" },
      icons = { mappings = false }
    }
    local wk = require("which-key")
    wk.add({
      { "<leader>h", group = "+hunks" },
      { "<leader>t", group = "+test" },
      { "<leader>l", group = "+lsp" },
      { "<leader>s", group = "+search" },
      { "<leader>b", group = "+buffer" }
    })
  end,
}
