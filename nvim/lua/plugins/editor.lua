return {
  {
    "nvim-mini/mini.ai",
    event = "VeryLazy",
    opts = function()
      local ai = require("mini.ai")
      return {
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
      }
    end,
  },
  {
    "nvim-mini/mini.pairs",
    event = { "InsertEnter", "CmdlineEnter" },
    opts = { modes = { command = true } },
  },
  {
    "nvim-mini/mini.surround",
    keys = {
      { "gsa", mode = { "n", "x" }, desc = "Add Surrounding" },
      { "gsd", desc = "Delete Surrounding" },
      { "gsf", desc = "Find Right Surrounding" },
      { "gsF", desc = "Find Left Surrounding" },
      { "gsh", desc = "Highlight Surrounding" },
      { "gsr", desc = "Replace Surrounding" },
      { "gsn", desc = "Update `MiniSurround.config.n_lines`" },
    },
    opts = {
      mappings = {
        add = "gsa",
        delete = "gsd",
        find = "gsf",
        find_left = "gsF",
        highlight = "gsh",
        replace = "gsr",
        update_n_lines = "gsn",
      },
    },
  },
  {
    "nvim-mini/mini.hipatterns",
    event = "LazyFile",
    opts = function()
      local hipatterns = require("mini.hipatterns")
      local function keyword(word, hl)
        return { pattern = "%f[%w]()" .. word .. "()%f[%W]", group = hl }
      end
      return {
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
      }
    end,
  },
  {
    "nvim-mini/mini.bufremove",
    keys = {
      {
        "<leader>bd",
        function() require("mini.bufremove").delete(0, false) end,
        desc = "Delete Buffer",
      },
      {
        "<leader>bD",
        function() require("mini.bufremove").delete(0, true) end,
        desc = "Delete Buffer and Window",
      },
      {
        "<leader>bo",
        function()
          local cur = vim.api.nvim_get_current_buf()
          for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if buf ~= cur and vim.bo[buf].buflisted then
              require("mini.bufremove").delete(buf, false)
            end
          end
        end,
        desc = "Delete Other Buffers",
      },
      {
        "<leader>bi",
        function()
          for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if #vim.fn.win_findbuf(buf) == 0 then
              require("mini.bufremove").delete(buf, false)
            end
          end
        end,
        desc = "Delete Invisible Buffers",
      },
      {
        "<leader>bl",
        function()
          local cur = vim.api.nvim_get_current_buf()
          for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if buf < cur and vim.bo[buf].buflisted then
              require("mini.bufremove").delete(buf, false)
            end
          end
        end,
        desc = "Delete Buffers to the Left",
      },
      {
        "<leader>br",
        function()
          local cur = vim.api.nvim_get_current_buf()
          for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if buf > cur and vim.bo[buf].buflisted then
              require("mini.bufremove").delete(buf, false)
            end
          end
        end,
        desc = "Delete Buffers to the Right",
      },
    },
  },
  {
    "nvim-mini/mini.indentscope",
    event = { "LazyFile", "VeryLazy" },
    opts = function()
      return {
        -- mini.ai owns `ii`/`ai`, so keep the module's own mappings out of the way.
        mappings = { object_scope = "", object_scope_with_border = "", goto_top = "", goto_bottom = "" },
        draw = { animation = require("mini.indentscope").gen_animation.none() },
      }
    end,
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "helix",
      delay = 300,
      win = { border = "single" },
      spec = {
        { "<Leader><Tab>", group = "tabs" },
        { "<Leader>a", group = "ai", mode = { "n", "x" } },
        { "<Leader>b", group = "buffer" },
        { "<Leader>c", group = "code", mode = { "n", "x" } },
        { "<Leader>d", group = "debug" },
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
    },
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    -- stylua: ignore
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = "c", function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
  },
  {
    "MagicDuck/grug-far.nvim",
    cmd = { "GrugFar", "GrugFarWithin" },
    opts = { headerMaxWidth = 80 },
    keys = {
      {
        "<leader>sr",
        function()
          local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
          require("grug-far").open({
            transient = true,
            prefills = { filesFilter = ext and ext ~= "" and "*." .. ext or nil },
          })
        end,
        mode = { "n", "x" },
        desc = "Search and Replace",
      },
    },
  },
}
