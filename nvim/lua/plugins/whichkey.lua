return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
  end,
  config = function()
    require("which-key").setup {
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
