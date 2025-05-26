-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",

  -- editing support
  -- { import = "astrocommunity.editing-support.conform-nvim" },
  { import = "astrocommunity.editing-support.neogen" },

  -- Turn off luasnip
  { import = "astrocommunity.snippet.nvim-snippets" },

  -- lang
  { import = "astrocommunity.pack.lua" },
  { import = "astrocommunity.pack.cpp" },
  { import = "astrocommunity.pack.python-ruff" },
  { import = "astrocommunity.pack.astro" },
  { import = "astrocommunity.pack.typescript" },
  { import = "astrocommunity.pack.tailwindcss" },
  { import = "astrocommunity.pack.html-css" },
  { import = "astrocommunity.pack.go" },
  { import = "astrocommunity.pack.markdown" },

  -- Utils
  { import = "astrocommunity.fuzzy-finder.snacks-picker" },
  { import = "astrocommunity.recipes.picker-lsp-mappings" },
  { import = "astrocommunity.terminal-integration.vim-tmux-navigator" },
  { import = "astrocommunity.markdown-and-latex.markview-nvim" },
  { import = "astrocommunity.media.img-clip-nvim" },

  -- Motion
  { import = "astrocommunity.motion.mini-ai" },
  { import = "astrocommunity.motion.mini-surround" },
  { import = "astrocommunity.motion.flash-nvim" },

  -- import/override with your plugins folder
}
