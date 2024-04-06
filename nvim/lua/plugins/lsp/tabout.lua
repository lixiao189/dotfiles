-- Lua
return {
    {
        "kawre/neotab.nvim",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "L3MON4D3/LuaSnip",
            "hrsh7th/nvim-cmp"
        },
        event = 'InsertEnter',
        opts = {
            semicolon = {
                enabled = true,
                ft = { "cs", "c", "cpp", "java" },
            },
        }
    },
    {
        "L3MON4D3/LuaSnip",
        keys = function()
            -- Disable default tab keybinding in LuaSnip
            return {}
        end,
    },
}
