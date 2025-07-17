return {
  { -- Autocompletion
    "saghen/blink.cmp",
    event = "InsertEnter",
    version = "1.*",
    dependencies = {
      "folke/lazydev.nvim",
      "zbirenbaum/copilot.lua", -- AI
    },
    --- @module 'blink.cmp'
    --- @type blink.cmp.Config
    opts = {
      keymap = {
        preset = "enter",
        ["<Tab>"] = {
          "snippet_forward",
          function(_)
            local copilot = require("copilot.suggestion")
            if copilot.is_visible() then
              -- Create undo
              local create_undo = vim.api.nvim_replace_termcodes("<c-G>u", true, true, true)
              if vim.api.nvim_get_mode().mode == "i" then
                vim.api.nvim_feedkeys(create_undo, "n", false)
              end
              copilot.accept()
              return true
            end
          end,
          "fallback",
        },
      },

      appearance = {
        nerd_font_variant = "mono",
      },

      completion = {
        documentation = { auto_show = false, auto_show_delay_ms = 500 },
      },

      sources = {
        default = { "lsp", "path", "snippets", "lazydev" },
        providers = {
          lazydev = { module = "lazydev.integrations.blink", score_offset = 100 },
        },
      },

      -- Shows a signature help window while you type arguments for a function
      signature = { enabled = true },
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
