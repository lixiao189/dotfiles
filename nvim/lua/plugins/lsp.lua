return {
  {
    "Saghen/blink.cmp",
    opts = {
      sources = {
        default = { "lsp", "path", "snippets" },
      },
      keymap = {
        ["<Tab>"] = { "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "snippet_backward", "fallback" },
      },
      completion = {
        list = { selection = { preselect = true, auto_insert = false } },
        documentation = { auto_show = false },
      },
    },
  },

  -- 禁止安装 emment-ls
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = function(_, opts)
      for i, v in ipairs(opts.ensure_installed) do
        if v == "emmet-ls" then
          table.remove(opts.ensure_installed, i)
          break
        end
      end
    end,
  },

  -- Neogen snippet system 切换
  {
    "danymat/neogen",
    optional = true,
    opts = {
      snippet_engine = "nvim",
    },
  },
}
