return {
  "saghen/blink.cmp",
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
        show_on_blocked_trigger_characters = { " ", "\n", "\t", ";", ":" },
      },
    },
  },
}
