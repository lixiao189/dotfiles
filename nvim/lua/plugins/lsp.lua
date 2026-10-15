-- Native LSP: nvim-lspconfig only provides `lsp/<server>.lua` configs, overrides live in
-- `after/lsp/<server>.lua`, and servers are enabled with vim.lsp.enable().
-- mason.nvim installs missing servers/tools automatically (like LazyVim).

-- Servers to enable. Installed with mason when not found on $PATH (except `mason = false`).
---@type table<string, {mason?: boolean}>
local servers = {
  bashls = {},
  clangd = {},
  gopls = {},
  jsonls = {},
  lua_ls = {},
  marksman = {},
  neocmake = {},
  pyright = {},
  ruff = {},
  sourcekit = { mason = false }, -- ships with Xcode
  taplo = {},
  vtsls = {},
  yamlls = {},
}

-- Formatters / linters used by conform.nvim.
local tools = { "stylua", "shfmt", "gofumpt", "goimports", "prettier" }

vim.diagnostic.config({
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  virtual_text = { spacing = 4, source = "if_many", prefix = "●" },
  float = { source = "if_many" },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "\u{f057} ",
      [vim.diagnostic.severity.WARN] = "\u{f071} ",
      [vim.diagnostic.severity.HINT] = "\u{f0eb} ",
      [vim.diagnostic.severity.INFO] = "\u{f05a} ",
    },
  },
})

require("mason").setup()

---@param name string
local function executable(name)
  local cmd = vim.lsp.config[name] and vim.lsp.config[name].cmd
  return type(cmd) == "function" or (type(cmd) == "table" and vim.fn.executable(cmd[1]) == 1)
end

local to_enable, to_install = {}, {}
for name, opts in pairs(servers) do
  if opts.mason == false or executable(name) then
    to_enable[#to_enable + 1] = name
  else
    to_install[#to_install + 1] = name
  end
end
vim.lsp.enable(to_enable)

-- Install missing servers/tools in the background, enabling each server once it is ready.
local registry = require("mason-registry")
registry.refresh(vim.schedule_wrap(function()
  -- lspconfig name -> mason package, from the registry's own metadata
  local lsp_to_pkg = {}
  for _, spec in ipairs(registry.get_all_package_specs()) do
    local lspconfig = vim.tbl_get(spec, "neovim", "lspconfig")
    if lspconfig then
      lsp_to_pkg[lspconfig] = spec.name
    end
  end

  local function install(pkg_name, on_done)
    local ok, pkg = pcall(registry.get_package, pkg_name)
    if not ok then
      return vim.notify("mason: unknown package " .. pkg_name, vim.log.levels.WARN)
    end
    if pkg:is_installed() then
      return on_done and on_done()
    end
    if pkg:is_installing() then
      return
    end
    vim.notify("mason: installing " .. pkg_name)
    pkg:install(
      {},
      vim.schedule_wrap(function(success)
        if success then
          vim.notify("mason: installed " .. pkg_name)
          if on_done then
            on_done()
          end
        else
          vim.notify("mason: failed to install " .. pkg_name, vim.log.levels.ERROR)
        end
      end)
    )
  end

  for _, server in ipairs(to_install) do
    local pkg = lsp_to_pkg[server]
    if pkg then
      install(pkg, function()
        vim.lsp.enable(server)
      end)
    else
      vim.notify("mason: no package for LSP " .. server, vim.log.levels.WARN)
    end
  end
  for _, tool in ipairs(tools) do
    if vim.fn.executable(tool) == 0 then
      install(tool)
    end
  end
end))

-- Buffer-local LSP keymaps (LazyVim). Nvim's own defaults (grn, gra, grr, gri, grt, gO, K, an/in) stay.
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("config_lsp_attach", { clear = true }),
  callback = function(ev)
    local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
    local buf = ev.buf
    local function map(mode, lhs, rhs, desc, method)
      if method and not client:supports_method(method, buf) then
        return
      end
      vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = desc, nowait = true })
    end

    map("n", "gd", function()
      Snacks.picker.lsp_definitions()
    end, "Goto Definition", "textDocument/definition")
    map("n", "gr", function()
      Snacks.picker.lsp_references()
    end, "References", "textDocument/references")
    map("n", "gI", function()
      Snacks.picker.lsp_implementations()
    end, "Goto Implementation", "textDocument/implementation")
    map("n", "gy", function()
      Snacks.picker.lsp_type_definitions()
    end, "Goto Type Definition", "textDocument/typeDefinition")
    map("n", "gD", vim.lsp.buf.declaration, "Goto Declaration", "textDocument/declaration")
    map("n", "gai", function()
      Snacks.picker.lsp_incoming_calls()
    end, "Calls Incoming", "callHierarchy/incomingCalls")
    map("n", "gao", function()
      Snacks.picker.lsp_outgoing_calls()
    end, "Calls Outgoing", "callHierarchy/outgoingCalls")
    map("n", "gK", vim.lsp.buf.signature_help, "Signature Help", "textDocument/signatureHelp")
    map("i", "<C-k>", vim.lsp.buf.signature_help, "Signature Help", "textDocument/signatureHelp")
    map({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, "Code Action", "textDocument/codeAction")
    map({ "n", "x" }, "<leader>cc", vim.lsp.codelens.run, "Run Codelens", "textDocument/codeLens")
    map("n", "<leader>cC", function()
      vim.lsp.codelens.enable(true, { bufnr = buf })
    end, "Refresh & Display Codelens", "textDocument/codeLens")
    map("n", "<leader>cr", vim.lsp.buf.rename, "Rename", "textDocument/rename")
    map("n", "<leader>cR", function()
      Snacks.rename.rename_file()
    end, "Rename File")
    map("n", "<leader>cA", function()
      vim.lsp.buf.code_action({ apply = true, context = { only = { "source" }, diagnostics = {} } })
    end, "Source Action", "textDocument/codeAction")
    map("n", "<leader>co", function()
      vim.lsp.buf.code_action({ apply = true, context = { only = { "source.organizeImports" }, diagnostics = {} } })
    end, "Organize Imports", "textDocument/codeAction")
    map("n", "<leader>ss", function()
      Snacks.picker.lsp_symbols()
    end, "LSP Symbols", "textDocument/documentSymbol")
    map("n", "<leader>sS", function()
      Snacks.picker.lsp_workspace_symbols()
    end, "LSP Workspace Symbols", "workspace/symbol")

    if client:supports_method("textDocument/documentColor", buf) then
      vim.lsp.document_color.enable(true, { bufnr = buf })
    end
    if client:supports_method("textDocument/foldingRange", buf) then
      for _, win in ipairs(vim.fn.win_findbuf(buf)) do
        vim.wo[win][0].foldmethod = "expr"
        vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
      end
    end
    if client:supports_method("textDocument/linkedEditingRange", buf) then
      vim.lsp.linked_editing_range.enable(true, { client_id = client.id })
    end
  end,
})

vim.keymap.set("n", "<leader>cl", function()
  Snacks.picker.lsp_config()
end, { desc = "Lsp Info" })
vim.keymap.set("n", "<leader>cm", "<cmd>Mason<cr>", { desc = "Mason" })
