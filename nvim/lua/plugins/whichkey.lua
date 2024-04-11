return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
        vim.o.timeout = true
        vim.o.timeoutlen = 300
    end,
    config = function()
        require("which-key").setup {
            layout = { align = "center" }
        }
        local wk = require("which-key")
        wk.register({
            f = { name = "+find" },
            h = { name = "+hunks" },
            t = { name = "+test" },
            l = { name = "+lsp" },
        }, { prefix = "<leader>" })
    end,
}
