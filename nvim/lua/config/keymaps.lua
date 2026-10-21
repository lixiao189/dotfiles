local util = require("config.util")
local map = vim.keymap.set
local function root()
  return util.root()
end

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
map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "]b", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
map("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
map("n", "<leader>bd", function()
  Snacks.bufdelete()
end, { desc = "Delete Buffer" })
map("n", "<leader>bo", function()
  Snacks.bufdelete.other()
end, { desc = "Delete Other Buffers" })
map("n", "<leader>bi", function()
  Snacks.bufdelete({
    filter = function(b)
      return #vim.fn.win_findbuf(b) == 0
    end,
  })
end, { desc = "Delete Invisible Buffers" })
map("n", "<leader>bD", "<cmd>:bd<cr>", { desc = "Delete Buffer and Window" })
local function delete_side(left)
  local cur = vim.api.nvim_get_current_buf()
  Snacks.bufdelete({
    filter = function(b)
      return vim.bo[b].buflisted and (left and b < cur or not left and b > cur)
    end,
  })
end
map("n", "<leader>bl", function()
  delete_side(true)
end, { desc = "Delete Buffers to the Left" })
map("n", "<leader>br", function()
  delete_side(false)
end, { desc = "Delete Buffers to the Right" })

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

map("n", "<leader>l", "<cmd>PackUpdate<cr>", { desc = "Update Plugins (vim.pack)" })
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
map("n", "[q", vim.cmd.cprev, { desc = "Previous Quickfix" })
map("n", "]q", vim.cmd.cnext, { desc = "Next Quickfix" })
map("n", "<leader>xx", function()
  vim.diagnostic.setqflist()
end, { desc = "Diagnostics (Quickfix)" })
map("n", "<leader>xX", function()
  vim.diagnostic.setloclist()
end, { desc = "Buffer Diagnostics (Location List)" })

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
map("n", "]t", function()
  vim.fn.search(todo_vim_re, "W")
end, { desc = "Next Todo Comment" })
map("n", "[t", function()
  vim.fn.search(todo_vim_re, "bW")
end, { desc = "Previous Todo Comment" })
local function todo_pattern(keywords)
  return [[\b(]] .. table.concat(keywords, "|") .. [[):]]
end
map("n", "<leader>st", function()
  Snacks.picker.grep({ search = todo_pattern(todo_keywords), regex = true, live = false, cwd = root() })
end, { desc = "Todo" })
map("n", "<leader>sT", function()
  Snacks.picker.grep({ search = todo_pattern({ "TODO", "FIX", "FIXME" }), regex = true, live = false, cwd = root() })
end, { desc = "Todo/Fix/Fixme" })
map("n", "<leader>xt", function()
  vim.cmd("silent grep! " .. vim.fn.shellescape(todo_pattern(todo_keywords)) .. " " .. vim.fn.fnameescape(root()))
  vim.cmd.copen()
end, { desc = "Todo (Quickfix)" })

local function toggle_autoformat(buffer)
  return Snacks.toggle({
    name = "Auto Format (" .. (buffer and "Buffer" or "Global") .. ")",
    get = function()
      if buffer then
        return util.autoformat_enabled()
      end
      return vim.g.autoformat
    end,
    set = function(state)
      if buffer then
        vim.b.autoformat = state
      else
        vim.g.autoformat = state
        vim.b.autoformat = nil
      end
    end,
  })
end
toggle_autoformat():map("<leader>uf")
toggle_autoformat(true):map("<leader>uF")
Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
Snacks.toggle.diagnostics():map("<leader>ud")
Snacks.toggle.line_number():map("<leader>ul")
Snacks.toggle
  .option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2, name = "Conceal Level" })
  :map("<leader>uc")
Snacks.toggle
  .option("showtabline", { off = 0, on = vim.o.showtabline > 0 and vim.o.showtabline or 2, name = "Tabline" })
  :map("<leader>uA")
Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
Snacks.toggle.dim():map("<leader>uD")
Snacks.toggle.animate():map("<leader>ua")
Snacks.toggle.indent():map("<leader>ug")
Snacks.toggle.scroll():map("<leader>uS")
Snacks.toggle.profiler():map("<leader>dpp")
Snacks.toggle.profiler_highlights():map("<leader>dph")
Snacks.toggle.inlay_hints():map("<leader>uh")
Snacks.toggle.zoom():map("<leader>wm"):map("<leader>uZ")
Snacks.toggle.zen():map("<leader>uz")
map("n", "<leader>dps", function()
  Snacks.profiler.scratch()
end, { desc = "Profiler Scratch Buffer" })

map("n", "<leader>gg", function()
  Snacks.lazygit({ cwd = root() })
end, { desc = "Lazygit (Root Dir)" })
map("n", "<leader>gG", function()
  Snacks.lazygit()
end, { desc = "Lazygit (cwd)" })
map("n", "<leader>gL", function()
  Snacks.picker.git_log()
end, { desc = "Git Log (cwd)" })
map("n", "<leader>gb", function()
  Snacks.picker.git_log_line()
end, { desc = "Git Blame Line" })
map("n", "<leader>gf", function()
  Snacks.picker.git_log_file()
end, { desc = "Git Current File History" })
map("n", "<leader>gl", function()
  Snacks.picker.git_log({ cwd = root() })
end, { desc = "Git Log" })
map({ "n", "x" }, "<leader>gB", function()
  Snacks.gitbrowse()
end, { desc = "Git Browse (open)" })
map({ "n", "x" }, "<leader>gY", function()
  Snacks.gitbrowse({
    open = function(url)
      vim.fn.setreg("+", url)
    end,
    notify = false,
  })
end, { desc = "Git Browse (copy)" })
map("n", "<leader>gd", function()
  Snacks.picker.git_diff()
end, { desc = "Git Diff (hunks)" })
map("n", "<leader>gD", function()
  Snacks.picker.git_diff({ base = "origin", group = true })
end, { desc = "Git Diff (origin)" })
map("n", "<leader>gs", function()
  Snacks.picker.git_status()
end, { desc = "Git Status" })
map("n", "<leader>gS", function()
  Snacks.picker.git_stash()
end, { desc = "Git Stash" })
map("n", "<leader>gi", function()
  Snacks.picker.gh_issue()
end, { desc = "GitHub Issues (open)" })
map("n", "<leader>gI", function()
  Snacks.picker.gh_issue({ state = "all" })
end, { desc = "GitHub Issues (all)" })
map("n", "<leader>gp", function()
  Snacks.picker.gh_pr()
end, { desc = "GitHub Pull Requests (open)" })
map("n", "<leader>gP", function()
  Snacks.picker.gh_pr({ state = "all" })
end, { desc = "GitHub Pull Requests (all)" })

map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit All" })

map("n", "<leader>ui", vim.show_pos, { desc = "Inspect Pos" })

map("n", "<leader>fT", function()
  Snacks.terminal()
end, { desc = "Terminal (cwd)" })
map("n", "<leader>ft", function()
  Snacks.terminal(nil, { cwd = root() })
end, { desc = "Terminal (Root Dir)" })
map({ "n", "t" }, "<c-/>", function()
  Snacks.terminal(nil, { cwd = root() })
end, { desc = "Terminal (Root Dir)" })
map({ "n", "t" }, "<c-_>", function()
  Snacks.terminal(nil, { cwd = root() })
end, { desc = "which_key_ignore" })

map("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
map("n", "<leader><tab>o", "<cmd>tabonly<cr>", { desc = "Close Other Tabs" })
map("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
map("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
map("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
map("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
map("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

local P = function(name, opts)
  return function()
    local o = type(opts) == "function" and opts() or opts
    Snacks.picker[name](o)
  end
end
local root_opts = function()
  return { cwd = root() }
end
map("n", "<leader><space>", P("files", root_opts), { desc = "Find Files (Root Dir)" })
map("n", "<leader>,", P("buffers", { sort_lastused = true }), { desc = "Buffers" })
map("n", "<leader>/", P("grep", root_opts), { desc = "Grep (Root Dir)" })
map("n", "<leader>:", P("command_history"), { desc = "Command History" })
map("n", "<leader>n", P("notifications"), { desc = "Notification History" })
map("n", "<leader>un", function()
  Snacks.notifier.hide()
end, { desc = "Dismiss All Notifications" })
map("n", "<leader>.", function()
  Snacks.scratch()
end, { desc = "Toggle Scratch Buffer" })
map("n", "<leader>S", function()
  Snacks.scratch.select()
end, { desc = "Select Scratch Buffer" })
map("n", "<leader>e", function()
  Snacks.explorer({ cwd = root() })
end, { desc = "Explorer (Root Dir)" })
map("n", "<leader>E", function()
  Snacks.explorer()
end, { desc = "Explorer (cwd)" })
map("n", "<leader>fe", function()
  Snacks.explorer({ cwd = root() })
end, { desc = "Explorer (Root Dir)" })
map("n", "<leader>fE", function()
  Snacks.explorer()
end, { desc = "Explorer (cwd)" })
map("n", "<leader>fb", P("buffers"), { desc = "Buffers" })
map("n", "<leader>fB", P("buffers", { hidden = true, nofile = true }), { desc = "Buffers (all)" })
map("n", "<leader>fc", P("files", { cwd = vim.fn.stdpath("config") }), { desc = "Find Config File" })
map("n", "<leader>ff", P("files", root_opts), { desc = "Find Files (Root Dir)" })
map("n", "<leader>fF", P("files"), { desc = "Find Files (cwd)" })
map("n", "<leader>fg", P("git_files"), { desc = "Find Files (git-files)" })
map("n", "<leader>fp", P("projects"), { desc = "Projects" })
map("n", "<leader>fr", P("recent"), { desc = "Recent" })
map("n", "<leader>fR", P("recent", { filter = { cwd = true } }), { desc = "Recent (cwd)" })
map("n", '<leader>s"', P("registers"), { desc = "Registers" })
map("n", "<leader>s/", P("search_history"), { desc = "Search History" })
map("n", "<leader>sa", P("autocmds"), { desc = "Autocmds" })
map("n", "<leader>sb", P("lines"), { desc = "Buffer Lines" })
map("n", "<leader>sB", P("grep_buffers"), { desc = "Grep Open Buffers" })
map("n", "<leader>sc", P("command_history"), { desc = "Command History" })
map("n", "<leader>sC", P("commands"), { desc = "Commands" })
map("n", "<leader>sd", P("diagnostics"), { desc = "Diagnostics" })
map("n", "<leader>sD", P("diagnostics_buffer"), { desc = "Buffer Diagnostics" })
map("n", "<leader>sg", P("grep", root_opts), { desc = "Grep (Root Dir)" })
map("n", "<leader>sG", P("grep"), { desc = "Grep (cwd)" })
map("n", "<leader>sh", P("help"), { desc = "Help Pages" })
map("n", "<leader>sH", P("highlights"), { desc = "Highlights" })
map("n", "<leader>si", P("icons"), { desc = "Icons" })
map("n", "<leader>sj", P("jumps"), { desc = "Jumps" })
map("n", "<leader>sk", P("keymaps"), { desc = "Keymaps" })
map("n", "<leader>?", P("keymaps", { global = false }), { desc = "Buffer Keymaps" })
map("n", "<leader>sl", P("loclist"), { desc = "Location List" })
map("n", "<leader>sm", P("marks"), { desc = "Marks" })
map("n", "<leader>sM", P("man"), { desc = "Man Pages" })
map(
  "n",
  "<leader>sp",
  P("files", { cwd = vim.fn.stdpath("data") .. "/site/pack/core/opt" }),
  { desc = "Search Plugin Files" }
)
map("n", "<leader>sq", P("qflist"), { desc = "Quickfix List" })
map("n", "<leader>sR", P("resume"), { desc = "Resume" })
map("n", "<leader>su", function()
  vim.cmd.packadd("nvim.undotree")
  require("undotree").open()
end, { desc = "Undotree" })
map({ "n", "x" }, "<leader>sw", P("grep_word", root_opts), { desc = "Visual selection or word (Root Dir)" })
map({ "n", "x" }, "<leader>sW", P("grep_word"), { desc = "Visual selection or word (cwd)" })
map("n", "<leader>uC", P("colorschemes"), { desc = "Colorschemes" })

map({ "n", "x" }, "<leader>sr", function()
  local grug = require("grug-far")
  local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
  grug.open({ transient = true, prefills = { filesFilter = ext and ext ~= "" and "*." .. ext or nil } })
end, { desc = "Search and Replace" })

map({ "n", "x", "o" }, "s", function()
  require("flash").jump()
end, { desc = "Flash" })
map({ "n", "x", "o" }, "S", function()
  require("flash").treesitter()
end, { desc = "Flash Treesitter" })
map("o", "r", function()
  require("flash").remote()
end, { desc = "Remote Flash" })
map({ "o", "x" }, "R", function()
  require("flash").treesitter_search()
end, { desc = "Treesitter Search" })
map("c", "<c-s>", function()
  require("flash").toggle()
end, { desc = "Toggle Flash Search" })
