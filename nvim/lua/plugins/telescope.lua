return {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.6",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local builtin = require("telescope.builtin")
        vim.keymap.set("n", "<leader><space>", builtin.find_files, { desc = "Find Files" })
        vim.keymap.set("n", "<leader>/", builtin.live_grep, { desc = "Grep" })
        vim.keymap.set("n", "<leader>,", builtin.buffers, { desc = "Switch buffers" })
        vim.keymap.set("n", "<leader>g", builtin.git_status, { desc = "Git status" })
        require("telescope").setup({
            defaults = {
                mappings = {
                    n = {
                        ["<c-d>"] = require("telescope.actions").delete_buffer,
                    },
                    i = {
                        ["<C-h>"] = "which_key",
                        ["<c-d>"] = require("telescope.actions").delete_buffer,
                    },
                },
            },
        })
    end,
}
