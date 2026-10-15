-- clangd handles C/C++; sourcekit-lsp only Swift and Objective-C.
---@type vim.lsp.Config
return {
  filetypes = { "swift", "objc", "objcpp" },
}
