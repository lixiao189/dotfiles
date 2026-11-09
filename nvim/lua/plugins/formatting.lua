local util = require("config.util")

local prettier = { "prettier" }

---@param buf integer
---@return boolean
local function has_clang_format_config(buf)
  local name = vim.api.nvim_buf_get_name(buf)
  local dir = name ~= "" and vim.fn.fnamemodify(name, ":p:h") or vim.uv.cwd()
  return vim.fs.find({ ".clang-format", "_clang-format" }, {
    upward = true,
    path = dir,
    type = "file",
    limit = 1,
  })[1] ~= nil
end

return {
  "stevearc/conform.nvim",
  event = "BufWritePre",
  cmd = "ConformInfo",
  dependencies = { "mason-org/mason.nvim" },
  keys = {
    {
      "<leader>cf",
      function()
        require("conform").format()
      end,
      mode = { "n", "x" },
      desc = "Format",
    },
    {
      "<leader>cF",
      function()
        require("conform").format({ formatters = { "injected" } })
      end,
      mode = { "n", "x" },
      desc = "Format Injected Langs",
    },
  },
  init = function()
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  end,
  opts = {
    default_format_opts = { lsp_format = "fallback", timeout_ms = 3000 },
    formatters = {
      ["clang-format"] = {
        -- LLVM preset is 2-wide. Without a project .clang-format, use it at indent 4.
        prepend_args = function(_, ctx)
          if has_clang_format_config(ctx.buf) then
            return {}
          end
          return { "--style={BasedOnStyle: LLVM, IndentWidth: 4, TabWidth: 4, UseTab: Never}" }
        end,
      },
    },
    formatters_by_ft = {
      lua = { "stylua" },
      sh = { "shfmt" },
      bash = { "shfmt" },
      zsh = { "shfmt" },
      go = { "goimports", "gofumpt" },
      python = { "ruff_organize_imports", "ruff_format" },
      rust = { "rustfmt" },
      c = { "clang-format" },
      cpp = { "clang-format" },
      cmake = { "gersemi" },
      javascript = prettier,
      javascriptreact = prettier,
      typescript = prettier,
      typescriptreact = prettier,
      json = prettier,
      jsonc = prettier,
      yaml = prettier,
      markdown = prettier,
      css = prettier,
      html = prettier,
    },
    format_on_save = function(buf)
      if util.autoformat_enabled(buf) then
        return {}
      end
    end,
  },
}
