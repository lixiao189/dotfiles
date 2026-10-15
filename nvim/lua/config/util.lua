local M = {}

M.root_markers = { ".git", "lua" }

--- Root directory like LazyVim: LSP workspace folder containing the file -> root markers -> cwd.
---@param buf? integer
function M.root(buf)
  buf = (buf == nil or buf == 0) and vim.api.nvim_get_current_buf() or buf
  local path = vim.api.nvim_buf_get_name(buf)
  path = path ~= "" and vim.fs.normalize(vim.uv.fs_realpath(path) or path) or nil
  if path then
    for _, client in ipairs(vim.lsp.get_clients({ bufnr = buf })) do
      local roots = vim.tbl_map(function(ws)
        return vim.uri_to_fname(ws.uri)
      end, client.workspace_folders or {})
      if #roots == 0 and client.root_dir then
        roots = { client.root_dir }
      end
      for _, root in ipairs(roots) do
        if vim.fs.relpath(root, path) then
          return root
        end
      end
    end
  end
  return vim.fs.root(buf, M.root_markers) or vim.uv.cwd()
end

--- Format the buffer with conform (falls back to LSP).
function M.format(opts)
  require("conform").format(vim.tbl_extend("force", { lsp_format = "fallback", timeout_ms = 3000 }, opts or {}))
end

---@param buf? integer
function M.autoformat_enabled(buf)
  local b = vim.b[buf or 0].autoformat
  if b ~= nil then
    return b
  end
  return vim.g.autoformat
end

return M
