return {
  {
    "hrsh7th/cmp-buffer",
    enabled = false,
  },

  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      opts.sources = vim.tbl_filter(function(source)
        return source.name ~= "buffer"
      end, opts.sources or {})

      opts.performance = vim.tbl_deep_extend("force", opts.performance or {}, {
        debounce = 80,
        throttle = 40,
        fetching_timeout = 250,
        async_budget = 1,
        max_view_entries = 30,
      })
    end,
  },
}
