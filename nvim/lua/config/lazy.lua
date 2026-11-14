local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  local out = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({ { "Failed to clone lazy.nvim:\n", "ErrorMsg" }, { out, "WarningMsg" } }, true, {})
    return
  end
end
vim.opt.rtp:prepend(lazypath)

-- Buffer events for plugins that only matter once a real file is open.
local Event = require("lazy.core.handler.event")
Event.mappings.LazyFile = { id = "LazyFile", event = { "BufReadPost", "BufNewFile", "BufWritePre" } }

require("lazy").setup({
  spec = { { import = "plugins" } },
  defaults = { lazy = true },
  -- lazy.nvim also uses this timeout for build commands; Avante compiles Rust libraries.
  git = { timeout = 600 },
  install = { colorscheme = { "catppuccin-mocha", "habamax" } },
  change_detection = { notify = false },
  rocks = { enabled = false },
  ui = { border = "single", backdrop = 100 },
  performance = {
    rtp = {
      disabled_plugins = { "gzip", "netrwPlugin", "tarPlugin", "tohtml", "tutor", "zipPlugin" },
    },
  },
})
