-- Keymaps follow LazyVim's markdown extra.

-- Fallback for files with no markdownlint config of their own.
---@param buf integer
---@return string[]
local function markdownlint_config_args(buf)
  local has_config = vim.fs.root(buf, function(name)
    return name:match("^%.markdownlint[%w-]*%.%w+$") ~= nil
  end)
  return has_config and {} or { "--config", vim.fn.stdpath("config") .. "/markdownlint/.markdownlint.yaml" }
end

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = { marksman = {} },
      tools = { "markdownlint-cli2", "markdown-toc" },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = { markdown = { "prettier", "markdownlint-cli2", "markdown-toc" } },
      formatters = {
        -- --fix only files markdownlint flagged, so clean files are left alone.
        ["markdownlint-cli2"] = {
          condition = function(_, ctx)
            if not package.loaded["lint"] then
              return false
            end
            local ns = require("lint").get_namespace("markdownlint-cli2")
            return #vim.diagnostic.get(ctx.buf, { namespace = ns }) > 0
          end,
          prepend_args = function(_, ctx)
            return markdownlint_config_args(ctx.buf)
          end,
        },
        ["markdown-toc"] = {
          condition = function(_, ctx)
            return vim.iter(vim.api.nvim_buf_get_lines(ctx.buf, 0, -1, false)):any(function(line)
              return line:find("<!%-%- toc %-%->") ~= nil
            end)
          end,
        },
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    ft = "markdown",
    config = function()
      local lint = require("lint")
      local markdownlint = lint.linters["markdownlint-cli2"] --[[@as lint.Linter]]
      lint.linters_by_ft = { markdown = { "markdownlint-cli2" } }
      lint.linters["markdownlint-cli2"] = function()
        local args = vim.list_extend(vim.deepcopy(markdownlint.args or {}), markdownlint_config_args(0))
        return vim.tbl_extend("force", markdownlint, { args = args })
      end
      vim.api.nvim_create_autocmd({ "FileType", "BufReadPost", "BufWritePost", "InsertLeave" }, {
        group = vim.api.nvim_create_augroup("config_lint", { clear = true }),
        callback = function(ev)
          if vim.bo[ev.buf].buftype == "" then
            lint.try_lint()
          end
        end,
      })
    end,
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = "markdown",
    opts = {
      completions = { lsp = { enabled = true } },
      code = { sign = false, width = "block", right_pad = 1 },
      heading = { sign = false, icons = {} },
      checkbox = { enabled = false },
    },
    config = function(_, opts)
      require("render-markdown").setup(opts)
      Snacks.toggle({
        name = "Render Markdown",
        get = require("render-markdown").get,
        set = require("render-markdown").set,
      }):map("<leader>um")
    end,
  },
  {
    "iamcco/markdown-preview.nvim",
    ft = "markdown",
    -- From npm, not the prebuilt binary: its GitHub release download often times out.
    build = "cd app && npx --yes yarn install",
    init = function()
      vim.g.mkdp_auto_close = 0
    end,
    keys = {
      { "<leader>cp", ft = "markdown", "<cmd>MarkdownPreviewToggle<cr>", desc = "Markdown Preview" },
    },
  },
}
