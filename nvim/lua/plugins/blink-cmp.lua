---@type LazySpec
return {
  "saghen/blink.cmp",
  version = "v1.*",
  branch = "main",
  commit = "e84b7d9",
  opoptional = true,
  opts = {
    keymap = {
      ["<Tab>"] = {
        "snippet_forward",
        "fallback",
      },
      ["<S-Tab>"] = {
        "snippet_backward",
        "fallback",
      },
    },
    completion = {
      list = { selection = { preselect = true, auto_insert = false } },
      documentation = { auto_show = false },
      trigger = {
        show_on_blocked_trigger_characters = function(_)
          if vim.bo.filetype == "go" then return { " ", "\n", "\t", ":", ";" } end
          return { " ", "\n", "\t", ";" }
        end,
      },
    },
    fuzzy = {
      implementation = "lua",
    },
  },
}
