return {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.6",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        vim.keymap.set("n", "<leader><space>", "<cmd>Telescope find_files hidden=true no_ignore=true<cr>",
            { silent = true, noremap = true, desc = "Find Files" })
        vim.keymap.set("n", "<leader>/", "<cmd>Telescope live_grep no_ignore=true<cr>",
            { silent = true, noremap = true, desc = "Grep" })
        vim.keymap.set("n", "<leader>,", "<cmd>Telescope buffers<cr>",
            { silent = true, noremap = true, desc = "Switch buffers" })

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
                file_ignore_patterns = {
                    ".git/",
                    "node_modules/",
                    "vendor/",
                    "target/",
                    "dist/",
                    ".cache/",
                    ".vscode/",
                    ".idea/",
                    ".DS_Store",
                },
            },
        })
    end,
}
