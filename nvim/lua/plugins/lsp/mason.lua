return {
    "williamboman/mason.nvim",
    dependencies = {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    config = function()
        local mason = require("mason")
        local mason_tool_installer = require("mason-tool-installer")

        mason.setup({})
        mason_tool_installer.setup({
            ensure_installed = {
                "prettier", -- prettier formatter
                "isort",    -- python formatter
                "black",    -- python formatter
                "clangd",   -- c/c++ language server
                "volar",    -- vue language server
                "lua_ls",   -- lua language server
                "pylint",   -- python linter
                "eslint_d", -- js linter
            },
        })
    end
}
