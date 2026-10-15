-- rust-analyzer comes from rustup (`rustup component add rust-analyzer`), mason is only the fallback.
---@type vim.lsp.Config
return {
  settings = {
    ["rust-analyzer"] = {
      cargo = {
        allFeatures = true,
        loadOutDirsFromCheck = true,
        buildScripts = { enable = true },
      },
      -- Run clippy instead of `cargo check` on save.
      check = { command = "clippy" },
      procMacro = { enable = true },
      files = {
        exclude = { ".direnv", ".git", ".jj", "target" },
        watcher = "client",
      },
    },
  },
}
