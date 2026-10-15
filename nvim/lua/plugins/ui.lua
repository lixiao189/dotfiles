-- Colorscheme: match Ghostty (Latte when light, Mocha when dark) with a transparent background.
-- Neovim ships its own colors/catppuccin.vim, so load the plugin's per-flavour scheme explicitly.
require("catppuccin").setup({
  flavour = "auto",
  background = { light = "latte", dark = "mocha" },
  transparent_background = true,
  float = { transparent = true, solid = false },
  term_colors = true,
  lsp_styles = {
    underlines = {
      errors = { "undercurl" },
      hints = { "undercurl" },
      warnings = { "undercurl" },
      information = { "undercurl" },
    },
  },
})
local function apply_colorscheme()
  vim.cmd.colorscheme(vim.o.background == "light" and "catppuccin-latte" or "catppuccin-mocha")
end
apply_colorscheme()
-- The TUI re-detects the terminal background (e.g. system appearance change).
vim.api.nvim_create_autocmd("OptionSet", {
  pattern = "background",
  callback = function()
    if vim.g.colors_name and vim.g.colors_name:find("^catppuccin") then
      apply_colorscheme()
    end
  end,
})

require("mini.icons").setup()
MiniIcons.mock_nvim_web_devicons()

require("mini.statusline").setup()
require("mini.tabline").setup() -- buffer line

require("snacks").setup({
  bigfile = { enabled = true },
  dashboard = {
    enabled = true,
    preset = {
      keys = {
        { icon = "\u{f002} ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
        { icon = "\u{f15b} ", key = "n", desc = "New File", action = ":ene | startinsert" },
        { icon = "\u{f0b0} ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
        { icon = "\u{f1da} ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
        {
          icon = "\u{f013} ",
          key = "c",
          desc = "Config",
          action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
        },
        { icon = "\u{f1b8} ", key = "s", desc = "Restore Session", action = ":lua require('config.session').load()" },
        { icon = "󰒲 ", key = "u", desc = "Update Plugins", action = ":PackUpdate" },
        { icon = "\u{f08b} ", key = "q", desc = "Quit", action = ":qa" },
      },
    },
    sections = {
      { section = "header" },
      { section = "keys", gap = 1, padding = 1 },
      { section = "recent_files", icon = "\u{f15c} ", title = "Recent Files", indent = 2, padding = 1, limit = 5 },
    },
  },
  explorer = { enabled = true, replace_netrw = true },
  indent = { enabled = true },
  input = { enabled = true },
  notifier = { enabled = true },
  picker = { enabled = true },
  quickfile = { enabled = false },
  scope = { enabled = true },
  scroll = { enabled = true },
  statuscolumn = { enabled = true },
  words = { enabled = false },
})
