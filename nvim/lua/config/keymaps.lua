local util = require("config.util")
local map = vim.keymap.set
local root = util.root

map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

map("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window", remap = true })
map("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window", remap = true })
map("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window", remap = true })
map("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window", remap = true })
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })
map("n", "<leader>-", "<C-W>s", { desc = "Split Window Below", remap = true })
map("n", "<leader>|", "<C-W>v", { desc = "Split Window Right", remap = true })
map("n", "<leader>wd", "<C-W>c", { desc = "Delete Window", remap = true })

map("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down" })
map("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
map("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
map("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })

map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
map("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })

map({ "i", "n", "s" }, "<esc>", function()
  vim.cmd("noh")
  if vim.snippet.active() then
    vim.snippet.stop()
  end
  return "<esc>"
end, { expr = true, desc = "Escape and Clear hlsearch" })
map(
  "n",
  "<leader>ur",
  "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
  { desc = "Redraw / Clear hlsearch / Diff Update" }
)

-- n always searches forward, N backward
map("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" })
map({ "x", "o" }, "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
map("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result" })
map({ "x", "o" }, "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })

-- undo break-points
map("i", ",", ",<c-g>u")
map("i", ".", ".<c-g>u")
map("i", ";", ";<c-g>u")

map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })
map("n", "<leader>K", "<cmd>norm! K<cr>", { desc = "Keywordprg" })

map("x", "<", "<gv")
map("x", ">", ">gv")

map("n", "gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Below" })
map("n", "gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Above" })

map("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })
map("n", "<leader>L", "<cmd>help news<cr>", { desc = "Neovim News" })
map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

map("n", "<leader>xl", function()
  local ok, err = pcall(vim.fn.getloclist(0, { winid = 0 }).winid ~= 0 and vim.cmd.lclose or vim.cmd.lopen)
  if not ok and err then
    vim.notify(err, vim.log.levels.ERROR)
  end
end, { desc = "Location List" })
map("n", "<leader>xq", function()
  local ok, err = pcall(vim.fn.getqflist({ winid = 0 }).winid ~= 0 and vim.cmd.cclose or vim.cmd.copen)
  if not ok and err then
    vim.notify(err, vim.log.levels.ERROR)
  end
end, { desc = "Quickfix List" })
map("n", "<leader>xx", function()
  vim.diagnostic.setqflist()
end, { desc = "Diagnostics (Quickfix)" })
map("n", "<leader>xX", function()
  vim.diagnostic.setloclist()
end, { desc = "Buffer Diagnostics (Location List)" })
map("n", "[q", function()
  pcall(vim.cmd.cprevious)
end, { desc = "Previous Quickfix" })
map("n", "]q", function()
  pcall(vim.cmd.cnext)
end, { desc = "Next Quickfix" })

map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
local function diag_jump(count, severity)
  return function()
    vim.diagnostic.jump({ count = count, float = true, severity = severity and vim.diagnostic.severity[severity] })
  end
end
map("n", "]d", diag_jump(1), { desc = "Next Diagnostic" })
map("n", "[d", diag_jump(-1), { desc = "Prev Diagnostic" })
map("n", "]e", diag_jump(1, "ERROR"), { desc = "Next Error" })
map("n", "[e", diag_jump(-1, "ERROR"), { desc = "Prev Error" })
map("n", "]w", diag_jump(1, "WARN"), { desc = "Next Warning" })
map("n", "[w", diag_jump(-1, "WARN"), { desc = "Prev Warning" })

local todo_keywords = { "TODO", "FIX", "FIXME", "BUG", "HACK", "WARN", "PERF", "NOTE" }
local todo_vim_re = [[\v<(]] .. table.concat(todo_keywords, "|") .. [[)>]]
local function todo_pattern(keywords)
  return [[\b(]] .. table.concat(keywords, "|") .. [[):]]
end
map("n", "]t", function()
  vim.fn.search(todo_vim_re, "W")
end, { desc = "Next Todo Comment" })
map("n", "[t", function()
  vim.fn.search(todo_vim_re, "bW")
end, { desc = "Previous Todo Comment" })
map("n", "<leader>xt", function()
  vim.cmd("silent grep! " .. vim.fn.shellescape(todo_pattern(todo_keywords)) .. " " .. vim.fn.fnameescape(root()))
  vim.cmd.copen()
end, { desc = "Todo (Quickfix)" })

---@param name string
---@param get fun():any
---@param set fun(state:any)
local function toggle(name, get, set)
  return function()
    local state = not get()
    set(state)
    vim.notify(name .. ": " .. (state and "on" or "off"))
  end
end

local function toggle_autoformat(buffer)
  return toggle("Auto Format (" .. (buffer and "Buffer" or "Global") .. ")", function()
    if buffer then
      return util.autoformat_enabled()
    end
    return vim.g.autoformat
  end, function(state)
    if buffer then
      vim.b.autoformat = state
    else
      vim.g.autoformat = state
      vim.b.autoformat = nil
    end
  end)
end
map("n", "<leader>uf", toggle_autoformat(), { desc = "Toggle Auto Format (Global)" })
map("n", "<leader>uF", toggle_autoformat(true), { desc = "Toggle Auto Format (Buffer)" })

map("n", "<leader>us", toggle("Spelling", function()
  return vim.wo.spell
end, function(state)
  vim.wo.spell = state
end), { desc = "Toggle Spelling" })
map("n", "<leader>uw", toggle("Wrap", function()
  return vim.wo.wrap
end, function(state)
  vim.wo.wrap = state
end), { desc = "Toggle Wrap" })
map("n", "<leader>uL", toggle("Relative Number", function()
  return vim.wo.relativenumber
end, function(state)
  vim.wo.relativenumber = state
end), { desc = "Toggle Relative Number" })
map("n", "<leader>ud", toggle("Diagnostics", function()
  return vim.diagnostic.is_enabled()
end, function(state)
  vim.diagnostic.enable(state)
end), { desc = "Toggle Diagnostics" })
map("n", "<leader>ul", toggle("Line Numbers", function()
  return vim.wo.number
end, function(state)
  vim.wo.number = state
end), { desc = "Toggle Line Numbers" })
map("n", "<leader>uc", toggle("Conceal Level", function()
  return vim.wo.conceallevel > 0
end, function(state)
  vim.wo.conceallevel = state and (vim.wo.conceallevel > 0 and vim.wo.conceallevel or 2) or 0
end), { desc = "Toggle Conceal Level" })
map("n", "<leader>uA", toggle("Tabline", function()
  return vim.o.showtabline > 0
end, function(state)
  vim.o.showtabline = state and 2 or 0
end), { desc = "Toggle Tabline" })
map("n", "<leader>ub", toggle("Dark Background", function()
  return vim.o.background == "dark"
end, function(state)
  vim.o.background = state and "dark" or "light"
end), { desc = "Toggle Dark Background" })
map("n", "<leader>uT", toggle("Treesitter Highlight", function()
  return vim.treesitter.highlighter.active[vim.api.nvim_get_current_buf()] ~= nil
end, function(state)
  local buf = vim.api.nvim_get_current_buf()
  if state then
    vim.treesitter.start(buf)
  else
    vim.treesitter.stop(buf)
  end
end), { desc = "Toggle Treesitter Highlight" })
map("n", "<leader>uh", toggle("Inlay Hints", function()
  return vim.lsp.inlay_hint.is_enabled({ bufnr = 0 })
end, function(state)
  vim.lsp.inlay_hint.enable(state, { bufnr = 0 })
end), { desc = "Toggle Inlay Hints" })
map("n", "<leader>ug", toggle("Indent Scope", function()
  return not (vim.g.miniindentscope_disable == true)
end, function(state)
  vim.g.miniindentscope_disable = not state
end), { desc = "Toggle Indent Scope" })
map("n", "<leader>uS", toggle("Smooth Scroll", function()
  return vim.o.smoothscroll
end, function(state)
  vim.o.smoothscroll = state
end), { desc = "Toggle Smooth Scroll" })
map("n", "<leader>uI", function()
  vim.treesitter.inspect_tree()
end, { desc = "Inspect Tree" })
map("n", "<leader>ui", vim.show_pos, { desc = "Inspect Pos" })
map({ "n" }, "<leader>wm", util.zoom, { desc = "Toggle Zoom Mode" })
map("n", "<leader>uZ", util.zoom, { desc = "Toggle Zoom Mode" })

map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit All" })
map("n", "<leader>?", function()
  require("which-key").show({ global = false })
end, { desc = "Buffer Keymaps" })

map("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
map("n", "<leader><tab>o", "<cmd>tabonly<cr>", { desc = "Close Other Tabs" })
map("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
map("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
map("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
map("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
map("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })
