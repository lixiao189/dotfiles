local function is_local()
  local ssh_client = os.getenv "SSH_CLIENT"
  local ssh_connection = os.getenv "SSH_CONNECTION"
  local ssh_tty = os.getenv "SSH_TTY"

  return ssh_client == nil and ssh_connection == nil and ssh_tty == nil
end

---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  { import = "astrocommunity.pack.lua" },
  { import = "astrocommunity.pack.cpp" },
  { import = "astrocommunity.pack.python-ruff" },
  { import = "astrocommunity.pack.rust" },
  { import = "astrocommunity.pack.go" },

  { import = "astrocommunity.motion.flash-nvim" },
  { import = "astrocommunity.motion.mini-ai" },
  { import = "astrocommunity.editing-support.neogen" },
  { import = "astrocommunity.motion.mini-surround" },
  { import = "astrocommunity.completion.copilot-lua", cond = is_local() },
  { import = "astrocommunity.markdown-and-latex.markdown-preview-nvim", cond = is_local() },
}
