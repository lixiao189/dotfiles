-- Load basic editor configuration
require("basic")

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
require("lazy").setup("plugins", {
    -- Setup git mirrors
    git = {
        url_format = 'https://ghproxy.com/https://github.com/%s.git'
    },
    install = {
        colorscheme = { "habamax", "catppuccin-latte", "catppuccin" },
    }
})
