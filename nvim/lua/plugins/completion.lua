local cmp = require("cmp")
local compare = cmp.config.compare

vim.lsp.config("*", { capabilities = require("cmp_nvim_lsp").default_capabilities() })

local function truncate(s, max)
  return vim.fn.strchars(s) > max and vim.fn.strcharpart(s, 0, max - 1) .. "…" or s
end

local disabled_filetypes = { bigfile = true, snacks_picker_input = true, snacks_input = true }

local function bordered(winhighlight)
  -- Border comes from 'winborder'.
  return cmp.config.window.bordered({ winhighlight = winhighlight })
end

cmp.setup({
  enabled = function()
    return vim.bo.buftype ~= "prompt" and not disabled_filetypes[vim.bo.filetype]
  end,
  performance = {
    debounce = 10,
    throttle = 10,
    fetching_timeout = 200,
    filtering_context_budget = 5000,
    async_budget = 10,
    max_view_entries = 50,
  },
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
    { name = "buffer" },
  }),
  sorting = {
    comparators = {
      compare.offset,
      compare.exact,
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
  view = { docs = { auto_open = false } },
  mapping = {
    ["<C-Space>"] = cmp.mapping(function()
      if not cmp.visible() then
        cmp.complete()
      elseif cmp.visible_docs() then
        cmp.close_docs()
      else
        cmp.open_docs()
      end
    end, { "i" }),
    ["<C-e>"] = cmp.mapping(cmp.mapping.abort(), { "i" }),
    ["<C-y>"] = cmp.mapping(cmp.mapping.confirm({ select = true }), { "i" }),
    ["<Down>"] = cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }), { "i" }),
    ["<Up>"] = cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }), { "i" }),
    ["<C-n>"] = cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }), { "i" }),
    ["<C-p>"] = cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }), { "i" }),
    ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i" }),
    ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i" }),
    -- Otherwise fall through to mini.pairs' <CR>
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
