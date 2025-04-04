return {
  {
    "sainnhe/gruvbox-material",
    init = function ()
      vim.opt.background = "light"
      vim.g.gruvbox_material_better_performance = 1
      vim.g.gruvbox_material_background = "hard"
    end
  },
  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "gruvbox-material",
    },
  },
}
