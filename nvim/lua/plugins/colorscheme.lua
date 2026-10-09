-- Match Ghostty: light Catppuccin Latte, dark Catppuccin Mocha,
-- with the editor background left transparent so Ghostty's opacity shows through.
--
-- Neovim 0.12 ships its own colors/catppuccin.vim, which wins over the plugin's
-- colors/catppuccin.lua and ignores transparent_background. Load the plugin's
-- per-flavour colorscheme instead.
return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = function()
        vim.cmd.colorscheme(vim.o.background == "light" and "catppuccin-latte" or "catppuccin-mocha")
      end,
    },
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      flavour = "auto",
      background = {
        light = "latte",
        dark = "mocha",
      },
      transparent_background = true,
      float = {
        transparent = true,
        solid = false,
      },
      term_colors = true,
      lsp_styles = {
        underlines = {
          errors = { "undercurl" },
          hints = { "undercurl" },
          warnings = { "undercurl" },
          information = { "undercurl" },
        },
      },
    },
  },
}
