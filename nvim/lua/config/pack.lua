-- Thin helpers around the built-in plugin manager (:h vim.pack).
local M = {}

---@param repo string "owner/name"
function M.gh(repo)
  return "https://github.com/" .. repo
end

-- All plugins, added in one call so the first start asks for confirmation once.
-- Configuration lives in lua/plugins/*.lua.
local gh = M.gh
vim.pack.add({
  { src = gh("catppuccin/nvim"), name = "catppuccin" },
  gh("nvim-mini/mini.nvim"), -- ai, pairs, surround, clue, icons, statusline, tabline, hipatterns
  gh("folke/snacks.nvim"), -- picker, explorer, dashboard, notifier, terminal, lazygit, toggles
  gh("folke/flash.nvim"),
  gh("MagicDuck/grug-far.nvim"),
  gh("neovim/nvim-lspconfig"),
  gh("mason-org/mason.nvim"),
  gh("stevearc/conform.nvim"),
  gh("lewis6991/gitsigns.nvim"),
})

vim.api.nvim_create_user_command("PackUpdate", function(args)
  vim.pack.update(#args.fargs > 0 and args.fargs or nil)
end, {
  nargs = "*",
  desc = "Update plugins (review, then :write to apply)",
  complete = function()
    return vim.tbl_map(function(p)
      return p.spec.name
    end, vim.pack.get(nil, { info = false }))
  end,
})

vim.api.nvim_create_user_command("PackClean", function()
  local unused = vim
    .iter(vim.pack.get(nil, { info = false }))
    :filter(function(p)
      return not p.active
    end)
    :map(function(p)
      return p.spec.name
    end)
    :totable()
  if #unused == 0 then
    return vim.notify("No unused plugins")
  end
  if vim.fn.confirm("Delete unused plugins?\n" .. table.concat(unused, "\n"), "&Yes\n&No", 2) == 1 then
    vim.pack.del(unused)
  end
end, { desc = "Delete plugins that are no longer added" })

return M
