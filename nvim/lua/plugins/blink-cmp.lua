---@type LazySpec
return {
  { "friendly-snippets", enabled = false },
  {
    "saghen/blink.cmp",
    optional = true,
    opts = {
      completion = {
        list = { selection = { preselect = true, auto_insert = false } },
        documentation = { auto_show = false },
      },
      sources = {
        providers = {
          buffer = { min_keyword_length = 4 },
        },
      },
      fuzzy = {
        implementation = "lua",
      }
    },
  },
}
