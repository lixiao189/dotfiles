return {
  "saghen/blink.cmp",
  opts = {
    completion = {
      trigger = {
        show_on_trigger_character = false,
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = false },
    },
  },
}
