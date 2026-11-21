local disabled_filetypes = { bigfile = true, DressingInput = true }

return {
  "saghen/blink.cmp",
  branch = "main", -- Upstream v2 development branch.
  event = { "VeryLazy", "InsertEnter" },
  dependencies = {
    "saghen/blink.lib",
    "nvim-mini/mini.icons",
    "nvim-mini/mini.pairs",
  },
  build = function()
    assert(require("blink.cmp").build():pwait())
  end,
  opts = {
    enabled = function()
      return vim.bo.buftype ~= "prompt" and not disabled_filetypes[vim.bo.filetype]
    end,
    fuzzy = { implementation = "rust", sorts = { "exact", "score", "sort_text" } },
    cmdline = { enabled = false },
    term = { enabled = false },
    keymap = {
      preset = "default",
      ["<C-k>"] = false, -- LspAttach maps this to vim.lsp.buf.signature_help.
      ["<C-n>"] = { "select_next", "fallback" },
      ["<C-p>"] = { "select_prev", "fallback" },
      ["<CR>"] = { "accept", "fallback" }, -- Fall through to mini.pairs.
      ["<Tab>"] = { "accept", "snippet_forward", "fallback" },
    },
    sources = {
      default = { "lsp", "path", "buffer" },
      per_filetype = { lua = { "lazydev", inherit_defaults = true } },
      providers = {
        lazydev = {
          name = "LazyDev",
          module = "lazydev.integrations.blink",
          score_offset = 100,
          fallbacks = { "buffer" },
        },
        path = { opts = { trailing_slash = false } },
        buffer = {
          opts = {
            get_bufnrs = function()
              return { vim.api.nvim_get_current_buf() }
            end,
          },
        },
      },
    },
    completion = {
      list = { selection = { preselect = true, auto_insert = false } },
      accept = { auto_brackets = { enabled = false } },
      menu = {
        border = "single",
        winhighlight = "Normal:Pmenu,FloatBorder:PmenuBorder,CursorLine:PmenuSel,Search:None",
        draw = {
          components = {
            kind_icon = {
              text = function(ctx)
                return (require("mini.icons").get("lsp", ctx.kind))
              end,
            },
            label = {
              width = { max = 40 },
              text = function(ctx)
                return ctx.label
              end,
            },
            label_description = {
              width = { max = 20 },
              text = function(ctx)
                return vim.trim(ctx.label_description ~= "" and ctx.label_description or ctx.label_detail)
              end,
            },
          },
        },
      },
      documentation = {
        auto_show = false,
        window = {
          border = "single",
          winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,Search:None",
        },
      },
    },
  },
}
