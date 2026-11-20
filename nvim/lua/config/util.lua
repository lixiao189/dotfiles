local M = {}

-- Nearest ancestor of the buffer holding one of these is the project root.
-- `.git` first: a VCS checkout wins over the project files inside it.
M.root_markers = {
  ".git",
  ".hg",
  ".jj",
  ".svn",
  "CMakeLists.txt",
  "Cargo.toml",
  "Makefile",
  "compile_commands.json",
  "compile_flags.txt",
  ".clangd",
  "go.mod",
  "lua",
  "meson.build",
  "package.json",
  "pyproject.toml",
}

---@param buf? integer
---@return string
function M.root(buf)
  return vim.fs.root(buf or 0, M.root_markers) or vim.fn.getcwd()
end

vim.api.nvim_create_user_command("Root", function()
  local root = M.root()
  local marker = vim.iter(M.root_markers):find(function(m)
    return vim.uv.fs_stat(vim.fs.joinpath(root, m)) ~= nil
  end)
  vim.notify(
    ("%s (%s)"):format(vim.fn.fnamemodify(root, ":~"), marker or "cwd"),
    vim.log.levels.INFO,
    { title = "Project root" }
  )
end, { desc = "Project root" })

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
      vim.api.nvim_buf_call(buf, function()
        vim.cmd("silent! write")
      end)
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
