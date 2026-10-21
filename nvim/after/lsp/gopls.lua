---@type vim.lsp.Config
return {
  -- Neovim's libuv watcher (still advertised on macOS) stalls the UI on a large module.
  -- gopls watches from its own process instead.
  capabilities = {
    workspace = {
      didChangeWatchedFiles = {
        dynamicRegistration = false,
      },
    },
  },
  -- v0.22+ leaves semantic tokens off. lspconfig turns them back on; highlighting is treesitter.
  settings = {
    gopls = {
      semanticTokens = false,
      fileWatcher = "fsnotify",
    },
  },
}
