return {
  -- Swift lang
  "keith/swift.vim",
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        sourcekit = {
          root_dir = function(filename, _)
            local util = require("lspconfig.util")
            return util.root_pattern("buildServer.json")(filename)
              or util.root_pattern("*.xcodeproj", "*.xcworkspace")(filename)
              or vim.fs.dirname(vim.fs.find(".git", { path = filename, upward = true })[1])
              or util.root_pattern("Package.swift")(filename)
          end,
        },
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        swift = { "swiftformat" }, -- Install with brew
      },
    },
  },
}
