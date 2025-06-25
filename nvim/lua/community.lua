local function is_ssh() return os.getenv "SSH_TTY" ~= nil or os.getenv "SSH_CONNECTION" ~= nil end

---@type LazySpec
return {
  "AstroNvim/astrocommunity",

  -- Lang
  { import = "astrocommunity.pack.lua" },
  { import = "astrocommunity.pack.cpp" },
  { import = "astrocommunity.pack.python-ruff" },
  { import = "astrocommunity.pack.go" },
  { import = "astrocommunity.pack.typescript" },
  { import = "astrocommunity.pack.astro" },
  { import = "astrocommunity.pack.tailwindcss" },

  -- Utils
  { import = "astrocommunity.markdown-and-latex.markdown-preview-nvim", cond = function() return not is_ssh() end },
  { import = "astrocommunity.recipes.picker-lsp-mappings" },
  { import = "astrocommunity.editing-support.neogen" },
  { import = "astrocommunity.motion.mini-surround" },
  { import = "astrocommunity.motion.flash-nvim" },
  { import = "astrocommunity.editing-support.conform-nvim" },
  { import = "astrocommunity.snippet.nvim-snippets" },
}
