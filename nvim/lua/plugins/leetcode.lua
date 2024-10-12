return {
    "kawre/leetcode.nvim",
    build = ":TSUpdate html",
    cmd = "Leet",
    dependencies = {
        "nvim-telescope/telescope.nvim",
        "nvim-lua/plenary.nvim", -- required by telescope
        "MunifTanjim/nui.nvim",

        -- optional
        "nvim-treesitter/nvim-treesitter",
        "rcarriga/nvim-notify",
    },
    opts = {
        cn = { -- leetcode.cn
            enabled = true, ---@type boolean
            translator = true, ---@type boolean
            translate_problems = true, ---@type boolean
        },
    },
}
