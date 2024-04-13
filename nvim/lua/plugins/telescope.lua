return {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.6",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local builtin = require("telescope.builtin")
        vim.keymap.set("n", "<leader><space>", builtin.find_files, { desc = "Find Files" })
        vim.keymap.set("n", "<leader>/", builtin.live_grep, { desc = "Grep" })
        vim.keymap.set("n", "<leader>,", builtin.buffers, { desc = "Switch buffers" })

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
                    ".cache/",
                    ".vscode/",
                    ".idea/",
                    ".DS_Store",
                },
                sorting_strategy = "ascending",
                layout_config = {
                    horizontal = {
                        prompt_position = "top",
                        preview_width = 0.55,
                        results_width = 0.8,
                    },
                    vertical = {
                        mirror = false,
                    },
                    width = 0.87,
                    height = 0.80,
                    preview_cutoff = 120,
                },
            },
        })
    end,
}
