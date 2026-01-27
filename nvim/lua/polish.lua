vim.lsp.log.set_level("off")
vim.opt.guicursor = "n-v-i-c:block-Cursor"

-- Remove comment
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    vim.opt_local.formatoptions:remove({ 'r', 'o' })
  end,
})
