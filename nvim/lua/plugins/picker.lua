local util = require("config.util")

---@param name string
---@param opts? table|fun():table
local function pick(name, opts)
  return function()
    require("fzf-lua")[name](type(opts) == "function" and opts() or opts)
  end
end

local root = function()
  return { cwd = util.root() }
end

local todo_keywords = { "TODO", "FIX", "FIXME", "BUG", "HACK", "WARN", "PERF", "NOTE" }
---@param keywords string[]
---@return fun():table
local function todo(keywords)
  return function()
    return { search = [[\b(]] .. table.concat(keywords, "|") .. [[):]], regex = true, cwd = util.root() }
  end
end

---@param mode "word"|"visual"
---@param opts? table|fun():table
local function grep(mode, opts)
  return function()
    local fzf = require("fzf-lua")
    local o = type(opts) == "function" and opts() or opts
    if mode == "visual" then
      fzf.grep_visual(o)
    else
      fzf.grep_cword(o)
    end
  end
end

return {
  {
    "ibhagwan/fzf-lua",
    cmd = "FzfLua",
    keys = {
      -- files
      { "<leader><space>", pick("files", root), desc = "Find Files (Root Dir)" },
      { "<leader>,", pick("buffers", { sort_lastused = true }), desc = "Buffers" },
      { "<leader>/", pick("live_grep", root), desc = "Grep (Root Dir)" },
      { "<leader>:", pick("command_history"), desc = "Command History" },
      { "<leader>fb", pick("buffers", { sort_lastused = true }), desc = "Buffers" },
      {
        "<leader>fB",
        pick("buffers", { sort_lastused = true, show_unlisted = true }),
        desc = "Buffers (all)",
      },
      { "<leader>fc", pick("files", { cwd = vim.fn.stdpath("config") }), desc = "Find Config File" },
      { "<leader>ff", pick("files", root), desc = "Find Files (Root Dir)" },
      { "<leader>fF", pick("files"), desc = "Find Files (cwd)" },
      { "<leader>fg", pick("git_files"), desc = "Find Files (git-files)" },
      { "<leader>fp", pick("zoxide"), desc = "Projects" },
      { "<leader>fr", pick("oldfiles"), desc = "Recent" },
      { "<leader>fR", pick("oldfiles", root), desc = "Recent (cwd)" },
      -- search
      { "<leader>s/", pick("search_history"), desc = "Search History" },
      { '<leader>s"', pick("registers"), desc = "Registers" },
      { "<leader>sa", pick("autocmds"), desc = "Autocmds" },
      { "<leader>sb", pick("blines"), desc = "Buffer Lines" },
      { "<leader>sc", pick("command_history"), desc = "Command History" },
      { "<leader>sC", pick("commands"), desc = "Commands" },
      { "<leader>sd", pick("diagnostics_workspace"), desc = "Diagnostics" },
      { "<leader>sD", pick("diagnostics_document"), desc = "Buffer Diagnostics" },
      { "<leader>sg", pick("live_grep", root), desc = "Grep (Root Dir)" },
      { "<leader>sG", pick("live_grep"), desc = "Grep (cwd)" },
      { "<leader>sh", pick("helptags"), desc = "Help Pages" },
      { "<leader>sH", pick("highlights"), desc = "Highlights" },
      { "<leader>sj", pick("jumps"), desc = "Jumps" },
      { "<leader>sk", pick("keymaps"), desc = "Keymaps" },
      { "<leader>sl", pick("loclist"), desc = "Location List" },
      { "<leader>sm", pick("marks"), desc = "Marks" },
      { "<leader>sM", pick("manpages"), desc = "Man Pages" },
      {
        "<leader>sp",
        pick("files", { cwd = vim.fn.stdpath("data") .. "/lazy" }),
        desc = "Search Plugin Files",
      },
      { "<leader>sq", pick("quickfix"), desc = "Quickfix List" },
      { "<leader>sR", pick("resume"), desc = "Resume" },
      { "<leader>st", pick("grep", todo(todo_keywords)), desc = "Todo" },
      { "<leader>sT", pick("grep", todo({ "TODO", "FIX", "FIXME" })), desc = "Todo/Fix/Fixme" },
      { "<leader>su", pick("undotree"), desc = "Undotree" },
      { "<leader>sw", grep("word", root), mode = "n", desc = "Visual selection or word (Root Dir)" },
      { "<leader>sw", grep("visual", root), mode = "x", desc = "Visual selection (Root Dir)" },
      { "<leader>sW", grep("word"), mode = "n", desc = "Visual selection or word (cwd)" },
      { "<leader>sW", grep("visual"), mode = "x", desc = "Visual selection (cwd)" },
      -- git pickers
      { "<leader>gd", pick("git_hunks"), desc = "Git Diff (hunks)" },
      { "<leader>gD", pick("git_diff", { ref = "origin" }), desc = "Git Diff (origin)" },
      { "<leader>gl", pick("git_commits", root), desc = "Git Log" },
      { "<leader>gL", pick("git_commits"), desc = "Git Log (cwd)" },
      { "<leader>gb", pick("git_blame"), desc = "Git Blame" },
      { "<leader>gf", pick("git_bcommits"), desc = "Git Current File History" },
      { "<leader>gs", pick("git_status"), desc = "Git Status" },
      { "<leader>gS", pick("git_stash"), desc = "Git Stash" },
      -- ui
      { "<leader>uC", pick("colorschemes"), desc = "Colorschemes" },
    },
    opts = {
      winopts = {
        width = 0.80,
        height = 0.70,
        row = 0.5,
        col = 0.5,
        border = "rounded",
        backdrop = 60,
        treesitter = { enabled = false },
        preview = {
          layout = "flex",
          flip_columns = 120,
          horizontal = "right:55%",
          vertical = "down:45%",
          border = "rounded",
          title = true,
          scrollbar = false,
          winopts = { number = false, relativenumber = false, signcolumn = "no" },
        },
      },
      fzf_colors = true,
      prompt = "❯ ",
      fzf_opts = {
        ["--pointer"] = "❯",
        ["--marker"] = "✓",
        ["--info"] = "inline-right",
        ["--no-separator"] = true,
        ["--scrollbar"] = "",
      },
      keymap = {
        fzf = {
          true,
          ["ctrl-/"] = "toggle-preview",
          ["ctrl-q"] = "select-all+accept",
          ["ctrl-u"] = "half-page-up",
          ["ctrl-d"] = "half-page-down",
          ["ctrl-f"] = "preview-page-down",
          ["ctrl-b"] = "preview-page-up",
        },
        builtin = {
          true,
          ["<C-/>"] = "toggle-preview",
          ["<C-u>"] = "preview-page-up",
          ["<C-d>"] = "preview-page-down",
        },
      },
      files = {
        cwd_prompt = false,
        cwd_header = false,
        formatter = "path.filename_first",
        winopts = { preview = { hidden = true } },
      },
      buffers = { winopts = { preview = { hidden = true } } },
      oldfiles = {
        cwd_header = false,
        formatter = "path.filename_first",
        winopts = { preview = { hidden = true } },
      },
      grep = { cwd_header = false },
      lsp = {
        code_actions = { previewer = vim.fn.executable("delta") == 1 and "codeaction_native" or nil },
      },
    },
  },
  {
    "stevearc/dressing.nvim",
    lazy = false,
    opts = {
      input = { border = "single", win_options = { winblend = 0 } },
      select = { backend = { "builtin" }, builtin = { show_numbers = false } },
    },
  },
}
