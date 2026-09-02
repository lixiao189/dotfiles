return {
  {
    "neovim/nvim-lspconfig",
    init = function()
      local uv = vim.uv or vim.loop
      local default_publish = vim.lsp.handlers["textDocument/publishDiagnostics"]
      local pending = {}
      local timer = uv.new_timer()
      local DEBOUNCE_MS = 500

      local function flush()
        local batch = pending
        pending = {}
        vim.schedule(function()
          for _, p in pairs(batch) do
            default_publish(p.err, p.result, p.ctx, p.config)
          end
        end)
      end

      vim.lsp.handlers["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
        if err or not result or not result.uri then
          return default_publish(err, result, ctx, config)
        end
        -- latest diagnostics per client+buffer wins, the rest are coalesced
        pending[ctx.client_id .. ":" .. result.uri] = { err = err, result = result, ctx = ctx, config = config }
        if timer and not timer:is_active() then
          timer:start(DEBOUNCE_MS, 0, flush)
        end
      end
    end,
    opts = {
      inlay_hints = { enabled = false },
      servers = {
        clangd = {
          -- Keep live clang-tidy diagnostics; background indexing runs at low
          -- priority and total clangd worker concurrency is capped.
          cmd = {
            "clangd",
            "--background-index",
            "--background-index-priority=low",
            "--clang-tidy",
            "--header-insertion=iwyu",
            "--completion-style=detailed",
            "--function-arg-placeholders",
            "--fallback-style=llvm",
            "-j=2",
          },
        },
        sourcekit = {
          mason = false,
          filetypes = { "swift", "objc", "objcpp" },
        },
      },
    },
  },

  {
    "folke/noice.nvim",
    optional = true,
    opts = {
      lsp = {
        signature = {
          enabled = false,
        },
      },
    },
  },
}
