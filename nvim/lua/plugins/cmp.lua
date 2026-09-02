return {
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      -- Keep completion responsive while typing: update shortly after a burst of
      -- input, but do not let a slow source monopolize the main loop.
      opts.performance = vim.tbl_deep_extend("force", opts.performance or {}, {
        debounce = 20,
        throttle = 15,
        fetching_timeout = 250,
        async_budget = 1,
        max_view_entries = 30,
      })

      -- LSP remains immediately available. Path and buffer completion are more
      -- expensive, so wait for a useful prefix before querying them. Restricting
      -- cmp-buffer to the current buffer avoids rescanning every open buffer on
      -- each insert-mode update.
      for _, source in ipairs(opts.sources or {}) do
        if source.name == "nvim_lsp" then
          source.keyword_length = 1
          source.max_item_count = 30
        elseif source.name == "path" then
          source.keyword_length = 3
          source.max_item_count = 12
        elseif source.name == "buffer" then
          source.keyword_length = 4
          source.max_item_count = 12
          source.option = vim.tbl_deep_extend("force", source.option or {}, {
            get_bufnrs = function()
              return { vim.api.nvim_get_current_buf() }
            end,
          })
        elseif source.name == "snippets" then
          source.max_item_count = 12
        end
      end
    end,
  },
}
