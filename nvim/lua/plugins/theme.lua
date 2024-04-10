return {
    -- catppuccin
    {
        "catppuccin/nvim",
        name = "catppuccin",
        opts = {}
    },
    -- onedark 
    {
        "olimorris/onedarkpro.nvim",
        priority = 1000,     -- Ensure it loads first
        init = function ()
            vim.cmd("colorscheme onedark")
        end,
        opts = {
            options = { transparency = true }
        }
    }
}
