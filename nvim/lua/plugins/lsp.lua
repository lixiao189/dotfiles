-- lspconfig gives these a cmd function to prefer node_modules/.bin; it falls back to this binary.
local fn_cmd_bin = {
  jsonls = "vscode-json-language-server",
  yamlls = "yaml-language-server",
}

---@param name string
local function executable(name)
  local cmd = vim.lsp.config[name] and vim.lsp.config[name].cmd
  if type(cmd) == "table" then
    return vim.fn.executable(cmd[1]) == 1
  end
  if type(cmd) == "function" then
    local bin = fn_cmd_bin[name]
    return bin ~= nil and vim.fn.executable(bin) == 1
  end
  return false
end

---@param to_install string[]
---@param missing_tools string[]
local function ensure_installed(to_install, missing_tools)
  local registry = require("mason-registry")
  registry.refresh(vim.schedule_wrap(function()
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
    for _, tool in ipairs(missing_tools) do
      install(tool)
    end
  end))
end

return {
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        { path = "fzf-lua", words = { "FzfLua" } },
      },
    },
  },
  {
    "mason-org/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    opts = {},
  },
  {
    "neovim/nvim-lspconfig",
    event = "LazyFile",
    dependencies = { "mason-org/mason.nvim", "hrsh7th/cmp-nvim-lsp" },
    keys = {
      {
        "<leader>cl",
        "<cmd>checkhealth vim.lsp<cr>",
        desc = "Lsp Info",
      },
    },
    opts_extend = { "tools" },
    opts = {
      ---@type table<string, {mason?: boolean}>
      servers = {
        bashls = {},
        clangd = {},
        gopls = {},
        jsonls = {},
        lua_ls = {},
        neocmake = {},
        pyright = {},
        ruff = {},
        rust_analyzer = {},
        sourcekit = { mason = false }, -- ships with Xcode
        taplo = {},
        vtsls = {},
        yamlls = {},
      },
      -- rustfmt ships with rustup; mason's package is deprecated.
      tools = { "stylua", "shfmt", "gofumpt", "goimports", "prettier", "gersemi" },
    },
    config = function(_, opts)
      vim.lsp.semantic_tokens.enable(false)
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

      vim.lsp.config("*", { capabilities = require("cmp_nvim_lsp").default_capabilities() })

      local to_enable, to_install = {}, {}
      for name, server in pairs(opts.servers) do
        if server.mason == false or executable(name) then
          to_enable[#to_enable + 1] = name
        else
          to_install[#to_install + 1] = name
        end
      end
      vim.lsp.enable(to_enable)

      local missing_tools = vim.tbl_filter(function(tool)
        return vim.fn.executable(tool) == 0
      end, opts.tools)
      -- Skip the registry when nothing is missing: it is loaded, refreshed daily, and scanned.
      if #to_install > 0 or #missing_tools > 0 then
        ensure_installed(to_install, missing_tools)
      end

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
            require("fzf-lua").lsp_definitions()
          end, "Goto Definition", "textDocument/definition")
          map("n", "gr", function()
            require("fzf-lua").lsp_references()
          end, "References", "textDocument/references")
          map("n", "gI", function()
            require("fzf-lua").lsp_implementations()
          end, "Goto Implementation", "textDocument/implementation")
          map("n", "gy", function()
            require("fzf-lua").lsp_typedefs()
          end, "Goto Type Definition", "textDocument/typeDefinition")
          map("n", "gD", vim.lsp.buf.declaration, "Goto Declaration", "textDocument/declaration")
          map("n", "gai", function()
            require("fzf-lua").lsp_incoming_calls()
          end, "Calls Incoming", "callHierarchy/incomingCalls")
          map("n", "gao", function()
            require("fzf-lua").lsp_outgoing_calls()
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
            require("config.util").rename_file()
          end, "Rename File")
          map("n", "<leader>cA", function()
            vim.lsp.buf.code_action({ apply = true, context = { only = { "source" }, diagnostics = {} } })
          end, "Source Action", "textDocument/codeAction")
          map("n", "<leader>co", function()
            vim.lsp.buf.code_action({
              apply = true,
              context = { only = { "source.organizeImports" }, diagnostics = {} },
            })
          end, "Organize Imports", "textDocument/codeAction")
          map("n", "<leader>ss", function()
            require("fzf-lua").lsp_document_symbols()
          end, "LSP Symbols", "textDocument/documentSymbol")
          map("n", "<leader>sS", function()
            require("fzf-lua").lsp_workspace_symbols()
          end, "LSP Workspace Symbols", "workspace/symbol")

          if client.name == "clangd" then
            map("n", "<leader>ch", "<cmd>LspClangdSwitchSourceHeader<cr>", "Switch Source/Header (C/C++)")
          end

          if client:supports_method("textDocument/documentColor", buf) then
            vim.lsp.document_color.enable(true, { bufnr = buf })
          end
          if client:supports_method("textDocument/linkedEditingRange", buf) then
            vim.lsp.linked_editing_range.enable(true, { client_id = client.id })
          end
        end,
      })
    end,
  },
}
