local M = {}

---@param repo string "owner/name"
function M.gh(repo)
  return "https://github.com/" .. repo
end

-- Build hooks. Must be registered before the first vim.pack.add() so they also run on install.
vim.api.nvim_create_autocmd("PackChanged", {
  group = vim.api.nvim_create_augroup("config_pack", { clear = true }),
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if name == "nvim-treesitter" and kind == "update" then
      if not ev.data.active then
        vim.cmd.packadd("nvim-treesitter")
      end
      vim.cmd("TSUpdate")
    end
  end,
})

-- One call, so the first start asks for confirmation once.
local gh = M.gh
vim.pack.add({
  { src = gh("catppuccin/nvim"), name = "catppuccin" },
  gh("nvim-mini/mini.nvim"), -- ai, pairs, surround, icons, statusline, tabline, hipatterns
  gh("folke/snacks.nvim"), -- picker, explorer, dashboard, notifier, terminal, lazygit, toggles
  gh("folke/which-key.nvim"),
  gh("folke/flash.nvim"),
  gh("MagicDuck/grug-far.nvim"),
  gh("nvim-treesitter/nvim-treesitter"),
  gh("neovim/nvim-lspconfig"),
  gh("hrsh7th/nvim-cmp"),
  gh("hrsh7th/cmp-nvim-lsp"),
  gh("hrsh7th/cmp-buffer"),
  gh("hrsh7th/cmp-path"),
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
