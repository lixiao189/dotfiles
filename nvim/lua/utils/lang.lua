local M = {}

-- Extend capabilities for blink cmp
M.extend_capabilities = function(server_opt)
  local has_blink, blink = pcall(require, "blink.cmp")
  local capabilities = vim.tbl_deep_extend(
    "force",
    {},
    vim.lsp.protocol.make_client_capabilities(),
    has_blink and blink.get_lsp_capabilities() or {}
  )
  return vim.tbl_deep_extend("force", {
    capabilities = vim.deepcopy(capabilities),
  }, server_opt or {})
end

return M
