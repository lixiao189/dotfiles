return {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    init = function()
        vim.cmd.colorscheme "catppuccin"
        vim.opt.background = "light"
    end,
    opts = {
        transparent_background = true
    }
}
