-- Colorscheme: match Ghostty (Latte when light, Mocha when dark) with a transparent background.
-- Neovim ships its own colors/catppuccin.vim, so load the plugin's per-flavour scheme explicitly.
require("catppuccin").setup({
  transparent_background = true,
  float = { transparent = true },
  term_colors = true,
  custom_highlights = function(c)
    local none = c.none
    return {
      FloatBorder = { fg = c.surface2, bg = none },
      FloatTitle = { fg = c.subtext1, bg = none, style = { "bold" } },
      FloatFooter = { fg = c.overlay1, bg = none },
      Pmenu = { fg = c.overlay2, bg = none },
      PmenuBorder = { fg = c.surface2, bg = none },
      PmenuKind = { fg = c.blue, bg = none },
      PmenuExtra = { fg = c.overlay1, bg = none },
      PmenuSbar = { bg = none },
      PmenuThumb = { bg = c.surface1 },
      CmpItemMenu = { fg = c.overlay1 },
      WinSeparator = { fg = c.surface0 },
      SnacksPickerTitle = { fg = c.subtext1, bg = none, style = { "bold" } },
      SnacksPickerInputTitle = { fg = c.subtext1, bg = none, style = { "bold" } },
      SnacksPickerListTitle = { fg = c.subtext1, bg = none, style = { "bold" } },
      SnacksPickerPreviewTitle = { fg = c.subtext1, bg = none, style = { "bold" } },
      SnacksPickerPrompt = { fg = c.blue },
      SnacksPickerTree = { fg = c.surface1 },
      SnacksPickerListCursorLine = { bg = c.surface0 },
      SnacksNotifierBorderInfo = { link = "FloatBorder" },
      SnacksNotifierBorderWarn = { link = "FloatBorder" },
      SnacksNotifierBorderError = { link = "FloatBorder" },
      SnacksNotifierBorderDebug = { link = "FloatBorder" },
      SnacksNotifierBorderTrace = { link = "FloatBorder" },
      SnacksIndentScope = { fg = c.surface2 },
      WhichKeyNormal = { bg = none },
      WhichKeyBorder = { link = "FloatBorder" },
      WhichKeyTitle = { link = "FloatTitle" },
      WhichKeySeparator = { fg = c.surface2 },
      MiniTablineFill = { bg = none },
      MiniTablineCurrent = { fg = c.text, bg = none, style = { "bold" } },
      MiniTablineVisible = { fg = c.subtext0, bg = none },
      MiniTablineHidden = { fg = c.overlay1, bg = none },
      MiniTablineModifiedCurrent = { fg = c.peach, bg = none, style = { "bold" } },
      MiniTablineModifiedVisible = { fg = c.peach, bg = none },
      MiniTablineModifiedHidden = { fg = c.peach, bg = none },
      MiniTablineTabpagesection = { fg = c.overlay1, bg = none },
    }
  end,
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

require("mini.tabline").setup()

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
        { icon = "󰒲 ", key = "u", desc = "Update Plugins", action = ":PackUpdate" },
        { icon = "\u{f08b} ", key = "q", desc = "Quit", action = ":qa" },
      },
    },
    sections = {
      { section = "header" },
      { section = "keys", gap = 1, padding = 1 },
    },
  },
  explorer = { enabled = true, replace_netrw = true },
  indent = { enabled = true },
  input = { enabled = true },
  notifier = { enabled = true, style = "compact" },
  picker = {
    enabled = true,
    -- No dimming backdrop: it covers the translucent background with a solid layer.
    layout = {
      preset = function()
        return vim.o.columns >= 120 and "default" or "vertical"
      end,
      layout = { backdrop = false },
    },
    sources = {
      explorer = {
        layout = { preset = "sidebar", hidden = { "input", "preview" }, layout = { width = 30, min_width = 30 } },
        win = {
          list = {
            wo = {
              winbar = "%#StlExplorerHeader#  \u{f07c}  %{toupper(fnamemodify(getcwd(), ':t'))}",
              statuscolumn = " ",
              cursorline = true,
            },
          },
        },
      },
    },
  },
  scope = { enabled = true },
  statuscolumn = { enabled = true },
})
