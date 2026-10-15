-- Completion without blink.cmp/nvim-cmp:
--   * LSP buffers: vim.lsp.completion with autotrigger (snippets via vim.snippet, auto-imports, docs popup).
--   * Other buffers: 'autocomplete' with buffer words.
-- <Tab>/<S-Tab> select or jump snippet placeholders, <CR>/<C-y> accept, <C-Space> triggers, <C-e> cancels.

vim.o.autocomplete = true
-- No `u`: it reads unloaded buffers from disk on every keystroke.
vim.o.complete = ".^5,w^5,b^5"
vim.o.pumborder = "single"

local trigger_chars = {}
for c in ("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_"):gmatch(".") do
  trigger_chars[#trigger_chars + 1] = c
end

local group = vim.api.nvim_create_augroup("config_completion", { clear = true })

-- No word popup in prompts (picker search box, vim.ui.input).
vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = { "snacks_picker_input", "snacks_input" },
  callback = function(ev)
    vim.bo[ev.buf].autocomplete = false
  end,
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = group,
  callback = function(ev)
    local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
    if not client:supports_method("textDocument/completion", ev.buf) then
      return
    end
    -- Trigger on identifier characters too, not only the server's `.`/`:` etc.
    local provider = client.server_capabilities.completionProvider
    provider.triggerCharacters = vim.list.unique(vim.list_extend(provider.triggerCharacters or {}, trigger_chars))
    vim.lsp.completion.enable(true, client.id, ev.buf, {
      autotrigger = true,
      convert = function(item)
        -- Drop the argument list from function labels, the popup shows it already
        return { abbr = item.label:gsub("%b()", "") }
      end,
    })
    -- LSP drives the popup here; avoid two competing menus.
    vim.bo[ev.buf].autocomplete = false
  end,
})

local function pum_selected()
  return vim.fn.pumvisible() == 1 and vim.fn.complete_info({ "selected" }).selected ~= -1
end

vim.keymap.set("i", "<C-Space>", function()
  if next(vim.lsp.get_clients({ bufnr = 0, method = "textDocument/completion" })) then
    vim.lsp.completion.get()
  else
    vim.api.nvim_feedkeys(vim.keycode("<C-n>"), "n", false)
  end
end, { desc = "Trigger completion" })

vim.keymap.set("i", "<CR>", function()
  if pum_selected() then
    return vim.keycode("<C-y>")
  end
  -- MiniPairs.cr() returns already-escaped keys
  return (vim.fn.pumvisible() == 1 and vim.keycode("<C-e>") or "") .. MiniPairs.cr()
end, { expr = true, replace_keycodes = false, desc = "Accept completion / newline" })

vim.keymap.set({ "i", "s" }, "<Tab>", function()
  if vim.fn.pumvisible() == 1 then
    return "<C-n>"
  elseif vim.snippet.active({ direction = 1 }) then
    return "<Cmd>lua vim.snippet.jump(1)<CR>"
  end
  return "<Tab>"
end, { expr = true, desc = "Next completion / snippet placeholder" })

vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
  if vim.fn.pumvisible() == 1 then
    return "<C-p>"
  elseif vim.snippet.active({ direction = -1 }) then
    return "<Cmd>lua vim.snippet.jump(-1)<CR>"
  end
  return "<S-Tab>"
end, { expr = true, desc = "Prev completion / snippet placeholder" })
