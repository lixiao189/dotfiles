-- Catppuccin: Latte when light, Mocha when dark, transparent background.
-- Neovim ships its own colors/catppuccin.vim, so load the plugin's per-flavour scheme explicitly.
return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = {
      transparent_background = true,
      float = { transparent = true, solid = false },
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
          FzfLuaNormal = { fg = c.text, bg = none },
          FzfLuaBorder = { fg = c.surface2, bg = none },
          FzfLuaTitle = { fg = c.subtext1, bg = none, style = { "bold" } },
          FzfLuaPreviewTitle = { fg = c.subtext1, bg = none, style = { "bold" } },
          FzfLuaCursorLine = { bg = c.surface0 },
          FzfLuaSearch = { fg = c.blue, style = { "bold" } },
          FzfLuaDirIcon = { fg = c.blue },
          NeoTreeNormal = { bg = none },
          NeoTreeNormalNC = { bg = none },
          NeoTreeWinSeparator = { fg = c.surface0, bg = none },
          NeoTreeRootName = { fg = c.subtext1, style = { "bold" } },
          NeoTreeDirectoryName = { fg = c.blue },
          NeoTreeDirectoryIcon = { fg = c.blue },
          NeoTreeIndentMarker = { fg = c.surface1 },
          NeoTreeExpander = { fg = c.overlay1 },
          NeoTreeGitModified = { fg = c.peach },
          NeoTreeGitStaged = { fg = c.green },
          NeoTreeGitUntracked = { fg = c.yellow },
          NeoTreeGitDeleted = { fg = c.red },
          DashboardHeader = { fg = c.blue },
          DashboardCenter = { fg = c.subtext0 },
          DashboardShortCut = { fg = c.overlay1 },
          DashboardFooter = { fg = c.overlay1 },
          NotifyBackground = { link = "NormalFloat" },
          NotifyERRORBorder = { fg = c.red },
          NotifyWARNBorder = { fg = c.yellow },
          NotifyINFOBorder = { fg = c.blue },
          NotifyDEBUGBorder = { fg = c.overlay1 },
          NotifyTRACEBorder = { fg = c.mauve },
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
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
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
    end,
  },
  {
    "nvim-mini/mini.icons",
    opts = {},
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
  },
  { "nvim-mini/mini.tabline", lazy = false, opts = {} },
  {
    -- Reports go through nvim-notify so <leader>n can show the history.
    "rcarriga/nvim-notify",
    lazy = false,
    keys = {
      { "<leader>n", function() require("notify").show_history() end, desc = "Notification History" },
      {
        "<leader>un",
        function() require("notify").dismiss({ pending = true, silent = true }) end,
        desc = "Dismiss All Notifications",
      },
    },
    opts = { stages = "fade_in_slide_out", timeout = 2500, max_width = 60, background_colour = "#000000" },
    config = function(_, opts)
      local notify = require("notify")
      notify.setup(opts)
      vim.notify = notify
    end,
  },
  {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    cmd = "Dashboard",
    opts = {
      theme = "doom",
      config = {
        header = {
          "",
          "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗",
          "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║",
          "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║",
          "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║",
          "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║",
          "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝",
          "",
        },
        center = {
          {
            icon = " ",
            desc = "Find File",
            key = "f",
            action = function() require("fzf-lua").files({ cwd = require("config.util").root() }) end,
          },
          {
            icon = " ",
            desc = "Find Text",
            key = "g",
            action = function() require("fzf-lua").live_grep({ cwd = require("config.util").root() }) end,
          },
          {
            icon = " ",
            desc = "Recent Files",
            key = "r",
            action = function() require("fzf-lua").oldfiles() end,
          },
          {
            icon = " ",
            desc = "Explorer",
            key = "e",
            action = function() require("neo-tree.command").execute({ toggle = true, dir = require("config.util").root() }) end,
          },
          { icon = " ", desc = "New File", key = "n", action = ":ene | startinsert" },
          {
            icon = " ",
            desc = "Config",
            key = "c",
            action = function() require("fzf-lua").files({ cwd = vim.fn.stdpath("config") }) end,
          },
          { icon = " ", desc = "Update Plugins", key = "u", action = ":Lazy update" },
          { icon = " ", desc = "Quit", key = "q", action = ":qa" },
        },
        footer = function()
          local stats = require("lazy").stats()
          return { "⚡ Neovim " .. vim.version().major .. "." .. vim.version().minor .. " · " .. stats.loaded .. "/" .. stats.count .. " plugins loaded" }
        end,
      },
    },
  },
}
