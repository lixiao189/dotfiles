-- Text objects (LazyVim's mini.ai setup). `an`/`in` stay native: treesitter/LSP incremental selection.
local ai = require("mini.ai")
ai.setup({
  n_lines = 500,
  mappings = { around_next = "", inside_next = "" },
  custom_textobjects = {
    o = ai.gen_spec.treesitter({
      a = { "@block.outer", "@conditional.outer", "@loop.outer" },
      i = { "@block.inner", "@conditional.inner", "@loop.inner" },
    }),
    f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
    c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
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

-- TODO/FIXME/HACK/NOTE highlighting (todo-comments.nvim) and hex colors.
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

-- Key hints (which-key).
local clue = require("mini.clue")
clue.setup({
  triggers = {
    { mode = "n", keys = "<Leader>" },
    { mode = "x", keys = "<Leader>" },
    { mode = "n", keys = "g" },
    { mode = "x", keys = "g" },
    { mode = "n", keys = "[" },
    { mode = "n", keys = "]" },
    { mode = "n", keys = "z" },
    { mode = "x", keys = "z" },
    { mode = "n", keys = "'" },
    { mode = "n", keys = "`" },
    { mode = "n", keys = '"' },
    { mode = "x", keys = '"' },
    { mode = "i", keys = "<C-r>" },
    { mode = "c", keys = "<C-r>" },
    { mode = "n", keys = "<C-w>" },
  },
  clues = {
    { mode = "n", keys = "<Leader><Tab>", desc = "+tabs" },
    { mode = "n", keys = "<Leader>b", desc = "+buffer" },
    { mode = "n", keys = "<Leader>c", desc = "+code" },
    { mode = "x", keys = "<Leader>c", desc = "+code" },
    { mode = "n", keys = "<Leader>d", desc = "+debug" },
    { mode = "n", keys = "<Leader>dp", desc = "+profiler" },
    { mode = "n", keys = "<Leader>f", desc = "+file/find" },
    { mode = "n", keys = "<Leader>g", desc = "+git" },
    { mode = "x", keys = "<Leader>g", desc = "+git" },
    { mode = "n", keys = "<Leader>gh", desc = "+hunks" },
    { mode = "x", keys = "<Leader>gh", desc = "+hunks" },
    { mode = "n", keys = "<Leader>q", desc = "+quit/session" },
    { mode = "n", keys = "<Leader>s", desc = "+search" },
    { mode = "x", keys = "<Leader>s", desc = "+search" },
    { mode = "n", keys = "<Leader>u", desc = "+ui" },
    { mode = "n", keys = "<Leader>w", desc = "+windows" },
    { mode = "n", keys = "<Leader>x", desc = "+diagnostics/quickfix" },
    { mode = "n", keys = "gs", desc = "+surround" },
    { mode = "x", keys = "gs", desc = "+surround" },
    clue.gen_clues.square_brackets(),
    clue.gen_clues.builtin_completion(),
    clue.gen_clues.g(),
    clue.gen_clues.marks(),
    clue.gen_clues.registers(),
    clue.gen_clues.windows({ submode_resize = true }),
    clue.gen_clues.z(),
  },
  window = { delay = 300, config = { width = "auto" } },
})

require("flash").setup({})

require("grug-far").setup({ headerMaxWidth = 80 })
