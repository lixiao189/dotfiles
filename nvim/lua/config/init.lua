require("config.options") -- Load vim basic options
require("config.keymaps") -- Load vim keymaps options

-- Setup nvim package manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    -- "https://github.com/folke/lazy.nvim.git",
    "https://ghproxy.com/https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- Init the plugins
require("lazy").setup({
  spec = {
    { import = "plugins" },
  },
  -- Setup git mirrors
  git = {
    url_format = 'https://ghproxy.com/https://github.com/%s.git'
  },
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
