-- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
---@param args vim.api.keyset.create_autocmd.callback_args
---@param method string
---@return boolean
local function client_has(args, method)
  local client = vim.lsp.get_client_by_id(args.data.client_id)
  local bufnr = args.buf
  method = "textDocument/" .. method
  return client ~= nil and client:supports_method(method, bufnr)
end

return {
  {
    -- Main LSP Configuration
    "neovim/nvim-lspconfig",
    event = { "User FilePost" },
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      { "WhoIsSethDaniel/mason-tool-installer.nvim", opts_extend = { "ensure_installed" } },

      -- Allows extra capabilities provided by blink.cmp
      "saghen/blink.cmp",
    },
    config = function()
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
        callback = function(args)
          local map = function(keys, func, desc, mode)
            mode = mode or "n"
            vim.keymap.set(mode, keys, func, { buffer = args.buf, desc = desc })
          end

          map("gd", vim.lsp.buf.definition, "Goto Definition")
          map("gr", vim.lsp.buf.references, "References")
          map("gI", vim.lsp.buf.implementation, "Goto Implementation")
          map("gy", vim.lsp.buf.type_definition, "Goto T[y]pe Definition")
          map("gD", vim.lsp.buf.declaration, "Goto Declaration")
          map("K", function()
            return vim.lsp.buf.hover()
          end, "Hover")

          if client_has(args, "codeAction") then
            map("<leader>ca", vim.lsp.buf.code_action, "Code Action", { "n", "v" })
          end
          if client_has(args, "rename") then
            map("<leader>cr", vim.lsp.buf.rename, "Rename")
          end
        end,
      })

      -- Diagnostic Config
      -- See :help vim.diagnostic.Opts
      vim.diagnostic.config({
        severity_sort = true,
        float = { border = "rounded", source = "if_many" },
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = vim.g.have_nerd_font and {
          text = {
            [vim.diagnostic.severity.ERROR] = "󰅚 ",
            [vim.diagnostic.severity.WARN] = "󰀪 ",
            [vim.diagnostic.severity.INFO] = "󰋽 ",
            [vim.diagnostic.severity.HINT] = "󰌶 ",
          },
        } or {},
        virtual_text = {
          source = "if_many",
          spacing = 2,
          format = function(diagnostic)
            local diagnostic_message = {
              [vim.diagnostic.severity.ERROR] = diagnostic.message,
              [vim.diagnostic.severity.WARN] = diagnostic.message,
              [vim.diagnostic.severity.INFO] = diagnostic.message,
              [vim.diagnostic.severity.HINT] = diagnostic.message,
            }
            return diagnostic_message[diagnostic.severity]
          end,
        },
      })
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
