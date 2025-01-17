return {
  {
    "sainnhe/gruvbox-material",
    init = function()
      vim.g.gruvbox_material_background = "soft"
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "gruvbox-material",
    },
  },
}
