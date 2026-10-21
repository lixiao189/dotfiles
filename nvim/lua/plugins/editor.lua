local ai = require("mini.ai")
ai.setup({
  n_lines = 500,
  mappings = { around_next = "", inside_next = "" },
  custom_textobjects = {
    t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },
    d = { "%f[%d]%d+" },
    e = {
      { "%u[%l%d]+%f[^%l%d]", "%f[%S][%l%d]+%f[^%l%d]", "%f[%P][%l%d]+%f[^%l%d]", "^[%l%d]+%f[^%l%d]" },
      "^().*()$",
    },
    g = function()
      local from = { line = 1, col = 1 }
      local to = { line = vim.fn.line("$"), col = math.max(vim.fn.getline("$"):len(), 1) }
      return { from = from, to = to }
    end,
    u = ai.gen_spec.function_call(),
    U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }),
  },
})

require("mini.pairs").setup({
  modes = { insert = true, command = true, terminal = false },
})

require("mini.surround").setup({
  mappings = {
    add = "gsa",
    delete = "gsd",
    find = "gsf",
    find_left = "gsF",
    highlight = "gsh",
    replace = "gsr",
    update_n_lines = "gsn",
  },
})

local hipatterns = require("mini.hipatterns")
local function keyword(word, hl)
  return { pattern = "%f[%w]()" .. word .. "()%f[%W]", group = hl }
end
hipatterns.setup({
  highlighters = {
    fixme = keyword("FIXME", "MiniHipatternsFixme"),
    bug = keyword("BUG", "MiniHipatternsFixme"),
    hack = keyword("HACK", "MiniHipatternsHack"),
    warn = keyword("WARN", "MiniHipatternsHack"),
    todo = keyword("TODO", "MiniHipatternsTodo"),
    note = keyword("NOTE", "MiniHipatternsNote"),
    perf = keyword("PERF", "MiniHipatternsNote"),
    hex_color = hipatterns.gen_highlighter.hex_color(),
  },
})

require("which-key").setup({
  preset = "helix",
  delay = 300,
  -- Translucent terminal: no blending, borders match 'winborder'; colours come from ui.lua.
  win = { border = "single", wo = { winblend = 0 } },
  spec = {
    { "<Leader><Tab>", group = "tabs" },
    { "<Leader>b", group = "buffer" },
    { "<Leader>c", group = "code", mode = { "n", "x" } },
    { "<Leader>d", group = "debug" },
    { "<Leader>dp", group = "profiler" },
    { "<Leader>f", group = "file/find" },
    { "<Leader>g", group = "git", mode = { "n", "x" } },
    { "<Leader>gh", group = "hunks", mode = { "n", "x" } },
    { "<Leader>q", group = "quit/session" },
    { "<Leader>s", group = "search", mode = { "n", "x" } },
    { "<Leader>u", group = "ui" },
    { "<Leader>w", group = "windows" },
    { "<Leader>x", group = "diagnostics/quickfix" },
    { "gs", group = "surround", mode = { "n", "x" } },
    { "[", group = "prev" },
    { "]", group = "next" },
    { "g", group = "goto" },
    { "z", group = "fold" },
  },
})

require("flash").setup({})

require("grug-far").setup({ headerMaxWidth = 80 })
