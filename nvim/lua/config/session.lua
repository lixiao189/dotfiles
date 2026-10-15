-- Native sessions (persistence.nvim replacement): one :mksession file per working directory.
local M = {}

local dir = vim.fn.stdpath("state") .. "/sessions/"
local enabled = true

local function file(cwd)
  return dir .. (cwd or vim.fn.getcwd()):gsub("[\\/:]+", "%%") .. ".vim"
end

function M.save()
  vim.fn.mkdir(dir, "p")
  vim.cmd("mksession! " .. vim.fn.fnameescape(file()))
end

---@param path? string session file, defaults to the one for the cwd
function M.load(path)
  path = path or file()
  if vim.fn.filereadable(path) == 0 then
    return vim.notify("No session for " .. vim.fn.getcwd(), vim.log.levels.WARN)
  end
  vim.cmd("silent! %bwipeout!")
  vim.cmd("silent! source " .. vim.fn.fnameescape(path))
end

function M.list()
  local files = vim.fn.glob(dir .. "*.vim", true, true)
  table.sort(files, function(a, b)
    return vim.uv.fs_stat(a).mtime.sec > vim.uv.fs_stat(b).mtime.sec
  end)
  return files
end

function M.last()
  local f = M.list()[1]
  if f then
    M.load(f)
  end
end

function M.select()
  local items = vim.tbl_map(function(f)
    return { file = f, name = vim.fn.fnamemodify(f, ":t:r"):gsub("%%", "/") }
  end, M.list())
  vim.ui.select(items, {
    prompt = "Select a session",
    format_item = function(item)
      return vim.fn.fnamemodify(item.name, ":~")
    end,
  }, function(item)
    if item then
      M.load(item.file)
    end
  end)
end

vim.api.nvim_create_autocmd("VimLeavePre", {
  group = vim.api.nvim_create_augroup("config_session", { clear = true }),
  callback = function()
    -- Only save when real files are open
    local has_file = vim.iter(vim.api.nvim_list_bufs()):any(function(b)
      return vim.bo[b].buflisted and vim.bo[b].buftype == "" and vim.api.nvim_buf_get_name(b) ~= ""
    end)
    if enabled and has_file then
      M.save()
    end
  end,
})

vim.keymap.set("n", "<leader>qs", M.load, { desc = "Restore Session" })
vim.keymap.set("n", "<leader>qS", M.select, { desc = "Select Session" })
vim.keymap.set("n", "<leader>ql", M.last, { desc = "Restore Last Session" })
vim.keymap.set("n", "<leader>qd", function()
  enabled = false
end, { desc = "Don't Save Current Session" })

return M
