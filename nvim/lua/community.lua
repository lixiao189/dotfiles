---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  { import = "astrocommunity.recipes.picker-lsp-mappings" },

  -- Lang
  { import = "astrocommunity.pack.lua" },
  { import = "astrocommunity.pack.cpp" },
  { import = "astrocommunity.pack.python-ruff" },
  { import = "astrocommunity.pack.rust" },
  { import = "astrocommunity.pack.go" },
  { import = "astrocommunity.pack.prettier", cond = require("utils").is_local() },

  -- AI
  { import = "astrocommunity.recipes.ai" },
  { import = "astrocommunity.completion.copilot-vim", cond = require("utils").is_local() },

  -- Motion / Editing
  { import = "astrocommunity.motion.flash-nvim" },
  { import = "astrocommunity.motion.mini-ai" },
  { import = "astrocommunity.editing-support.neogen" },
  { import = "astrocommunity.motion.mini-surround" },
  { import = "astrocommunity.markdown-and-latex.markdown-preview-nvim", cond = require("utils").is_local() },
}
