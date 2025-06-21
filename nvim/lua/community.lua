---@type LazySpec
return {
  "AstroNvim/astrocommunity",

  -- Lang
  { import = "astrocommunity.pack.lua" },
  { import = "astrocommunity.pack.cpp" },
  { import = "astrocommunity.pack.python-ruff" },
  { import = "astrocommunity.pack.typescript" },
  { import = "astrocommunity.pack.astro" },
  { import = "astrocommunity.pack.tailwindcss" },

  -- Utils
  { import = "astrocommunity.editing-support.conform-nvim" },
  { import = "astrocommunity.editing-support.neogen" },
  { import = "astrocommunity.lsp.nvim-lint" },
  { import = "astrocommunity.motion.mini-ai" },
  { import = "astrocommunity.motion.mini-surround" },
  { import = "astrocommunity.motion.flash-nvim" },
}
