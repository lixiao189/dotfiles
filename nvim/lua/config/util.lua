local M = {}

M.root_markers = { ".git", "lua" }

---@param buf? integer
---@return string
function M.root(buf)
  if not buf or buf == 0 then
    buf = vim.api.nvim_get_current_buf()
  end
  local name = vim.api.nvim_buf_get_name(buf)
  local path = name ~= "" and vim.fs.normalize(vim.uv.fs_realpath(name) or name) or nil
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
  return vim.fs.root(buf, M.root_markers) or vim.fn.getcwd()
end

---@param buf? integer
function M.autoformat_enabled(buf)
  local b = vim.b[buf or 0].autoformat
  if b ~= nil then
    return b
  end
  return vim.g.autoformat
end

--- Zoom mode: the current buffer in its own tab, original layout untouched.
local zoom = {}
function M.zoom()
  local tab = vim.api.nvim_get_current_tabpage()
  if zoom.tab and vim.api.nvim_tabpage_is_valid(zoom.tab) and zoom.tab == tab then
    pcall(vim.cmd, "tabclose")
    zoom.tab = nil
    if zoom.origin and vim.api.nvim_tabpage_is_valid(zoom.origin) then
      vim.api.nvim_set_current_tabpage(zoom.origin)
    end
    zoom.origin = nil
    return
  end
  zoom.origin = tab
  vim.cmd("tab split")
  zoom.tab = vim.api.nvim_get_current_tabpage()
end

--- Rename the current file on disk, keeping the buffer attached to the new path.
function M.rename_file()
  local buf = vim.api.nvim_get_current_buf()
  local old = vim.api.nvim_buf_get_name(buf)
  if old == "" then
    return vim.notify("Rename: the buffer has no file", vim.log.levels.WARN)
  end
  vim.ui.input({ prompt = "New path: ", default = old, completion = "file" }, function(input)
    if not input or input == "" or input == old then
      return
    end
    local new = vim.fn.fnamemodify(vim.fn.expand(input), ":p")
    if new == old then
      return
    end
    if vim.uv.fs_stat(new) then
      return vim.notify("Rename: " .. new .. " already exists", vim.log.levels.ERROR)
    end
    if vim.bo[buf].modified then
      vim.api.nvim_buf_call(buf, function() vim.cmd("silent! write") end)
    end
    vim.fn.mkdir(vim.fn.fnamemodify(new, ":h"), "p")
    local ok, err = vim.uv.fs_rename(old, new)
    if not ok then
      return vim.notify("Rename failed: " .. tostring(err), vim.log.levels.ERROR)
    end
    vim.api.nvim_buf_set_name(buf, new)
    vim.cmd("silent! edit")
    vim.notify("Renamed to " .. vim.fn.fnamemodify(new, ":~:."))
  end)
end

return M
