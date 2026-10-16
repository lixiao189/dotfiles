-- Completion on nvim-cmp, tuned for typing latency:
--   * Sources: LSP + path; buffer words only when those have nothing (visible, non-huge buffers).
--   * Snippets expand with the native vim.snippet, no snippet engine.
--   * No ghost text, no locality comparator, capped entry count, short fetch timeout.
--   * Windows draw over the translucent terminal: no fill, no blend, single borders.
-- Keys follow VS Code: the first item (or the server's preselected one) is highlighted, <CR>/<Tab>
-- accept it, <Up>/<Down> (<C-n>/<C-p>) move, <C-Space> triggers, <C-e> cancels;
-- <Tab>/<S-Tab> jump snippet placeholders when the menu is closed.

local cmp = require("cmp")
local compare = cmp.config.compare

-- 'pumborder' still styles the cmdline popup menu.
vim.o.pumborder = "single"

vim.lsp.config("*", { capabilities = require("cmp_nvim_lsp").default_capabilities() })

-- Servers like clangd rank case-insensitively (`name` puts NAME_MAX above namespace);
-- prefer items that start with the typed text in the same case.
local function case_match(entry)
  local input = entry.context.cursor_before_line:sub(entry:get_offset())
  return vim.startswith(entry:get_filter_text(), input)
end
local function compare_case(a, b)
  local ca, cb = case_match(a), case_match(b)
  if ca ~= cb then
    return ca
  end
end

local max_buffer_size = 1024 * 1024
local function visible_buffers()
  local bufs = {}
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local buf = vim.api.nvim_win_get_buf(win)
    if
      vim.bo[buf].buftype == ""
      and vim.api.nvim_buf_get_offset(buf, vim.api.nvim_buf_line_count(buf)) < max_buffer_size
    then
      bufs[buf] = true
    end
  end
  return vim.tbl_keys(bufs)
end

local function truncate(s, max)
  return vim.fn.strchars(s) > max and vim.fn.strcharpart(s, 0, max - 1) .. "…" or s
end

local disabled_filetypes = { bigfile = true, snacks_picker_input = true, snacks_input = true }

local function bordered(winhighlight)
  return cmp.config.window.bordered({ border = "single", winhighlight = winhighlight, winblend = 0 })
end

cmp.setup({
  enabled = function()
    return vim.bo.buftype ~= "prompt" and not disabled_filetypes[vim.bo.filetype]
  end,
  performance = {
    debounce = 20,
    throttle = 20,
    fetching_timeout = 200,
    confirm_resolve_timeout = 80,
    async_budget = 1,
    max_view_entries = 50,
  },
  preselect = cmp.PreselectMode.Item,
  completion = { completeopt = "menu,menuone,noinsert" },
  snippet = {
    expand = function(args)
      vim.snippet.expand(args.body)
    end,
  },
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "path" },
  }, {
    {
      name = "buffer",
      keyword_length = 3,
      option = { get_bufnrs = visible_buffers, max_indexed_line_length = 512 },
    },
  }),
  sorting = {
    comparators = {
      compare.offset,
      compare.exact,
      compare_case,
      compare.score,
      compare.recently_used,
      compare.sort_text,
      compare.length,
      compare.order,
    },
  },
  formatting = {
    fields = { "kind", "abbr", "menu" },
    format = function(entry, item)
      item.kind = (MiniIcons.get("lsp", item.kind or "Text"))
      -- Drop the argument list from function labels, the docs window shows it already
      item.abbr = truncate((item.abbr:gsub("%b()", "")), 40)
      local details = entry.completion_item.labelDetails
      item.menu = details and (details.description or details.detail) or nil
      item.menu = item.menu and truncate(vim.trim(item.menu), 20)
      return item
    end,
  },
  window = {
    completion = bordered("Normal:Pmenu,FloatBorder:PmenuBorder,CursorLine:PmenuSel,Search:None"),
    documentation = bordered("Normal:NormalFloat,FloatBorder:FloatBorder,Search:None"),
  },
  experimental = { ghost_text = false },
  mapping = {
    ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i" }),
    ["<C-e>"] = cmp.mapping(cmp.mapping.abort(), { "i" }),
    ["<C-y>"] = cmp.mapping(cmp.mapping.confirm({ select = true }), { "i" }),
    ["<Down>"] = cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }), { "i" }),
    ["<Up>"] = cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }), { "i" }),
    ["<C-n>"] = cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }), { "i" }),
    ["<C-p>"] = cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }), { "i" }),
    ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i" }),
    ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i" }),
    -- Accept the highlighted item; with the menu closed fall through to mini.pairs' <CR>.
    ["<CR>"] = cmp.mapping(function(fallback)
      if cmp.visible() and cmp.get_selected_entry() then
        cmp.confirm()
      else
        fallback()
      end
    end, { "i" }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() and cmp.get_selected_entry() then
        cmp.confirm()
      elseif vim.snippet.active({ direction = 1 }) then
        vim.snippet.jump(1)
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if vim.snippet.active({ direction = -1 }) then
        vim.snippet.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  },
})
