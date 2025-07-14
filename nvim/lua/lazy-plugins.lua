require("lazy").setup({
  "NMAC427/guess-indent.nvim", -- Detect tabstop and shiftwidth automatically
  { import = "plugins" },
  { import = "lang" },
}, {
  defaults = {
    lazy = false,
  },
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

-- vim: ts=2 sts=2 sw=2 et
