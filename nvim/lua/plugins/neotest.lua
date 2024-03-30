return {
    "nvim-neotest/neotest",
    dependencies = {
        "nvim-neotest/nvim-nio",
        "nvim-lua/plenary.nvim",
        "antoinemadec/FixCursorHold.nvim",
        "nvim-treesitter/nvim-treesitter",

        -- Other adapters here
        "nvim-neotest/neotest-go",
    },
    config = function()
        -- Keybindings 
        vim.api.nvim_set_keymap("n", "<leader>ts", "<cmd>Neotest summary<CR>", { noremap = true, silent = true, desc = "summary panel" })
        vim.api.nvim_set_keymap("n", "<leader>tr", "<cmd>Neotest run<CR>", { noremap = true, silent = true, desc = "run test" })
        vim.api.nvim_set_keymap("n", "<leader>to", "<cmd>Neotest output-panel<CR>", { noremap = true, silent = true, desc = "summary panel" })

        require("neotest").setup({
            adapters = {
                require("neotest-go"),
            },
        })
    end,
}
