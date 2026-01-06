---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  { import = "astrocommunity.pack.lua" },
  { import = "astrocommunity.pack.cpp" },
  { import = "astrocommunity.pack.python-ruff" },
  { import = "astrocommunity.pack.rust" },
  { import = "astrocommunity.pack.go" },
  { import = "astrocommunity.pack.prettier", cond = require("utils").is_local() },

  { import = "astrocommunity.motion.flash-nvim" },
  { import = "astrocommunity.motion.mini-ai" },
  { import = "astrocommunity.editing-support.neogen" },
  { import = "astrocommunity.motion.mini-surround" },
  { import = "astrocommunity.completion.copilot-lua", cond = require("utils").is_local() },
  { import = "astrocommunity.markdown-and-latex.markdown-preview-nvim", cond = require("utils").is_local() },
}
