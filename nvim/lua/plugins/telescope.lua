return {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.6",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local builtin = require('telescope.builtin')
        vim.keymap.set("n", "<leader><space>", builtin.find_files, { silent = true, noremap = true, desc = "Find Files" })
        vim.keymap.set("n", "<leader>/", builtin.live_grep, { silent = true, noremap = true, desc = "Grep" })
        vim.keymap.set("n", "<leader>,", builtin.buffers, { silent = true, noremap = true, desc = "Switch buffers" })

        local actions = require "telescope.actions"
        require("telescope").setup({
            defaults = {
                mappings = {
                    n = {
                        ["<c-d>"] = actions.delete_buffer + actions.move_to_top,
                    },
                    i = {
                        ["<C-h>"] = "which_key",
                        ["<c-d>"] = actions.delete_buffer + actions.move_to_top,
                    },
                },
            },
        })
    end,
}
