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

---@param cmd string[]
---@return string stdout
local function run(cmd)
  local out = vim.system(cmd, { text = true }):wait()
  if out.code ~= 0 then
    error(("`%s` failed: %s"):format(table.concat(cmd, " "), out.stderr))
  end
  return out.stdout
end

-- Fetches the prebuilt server through the API: github.com release links can time out.
---@param plugin LazyPlugin
local function build_preview_server(plugin)
  local version = vim.json.decode(table.concat(vim.fn.readfile(plugin.dir .. "/package.json"))).version
  local platform = vim.fn.has("mac") == 1 and "macos" or "linux"
  local arch = vim.uv.os_uname().machine == "arm64" and "-arm64" or ""
  local asset = ("markdown-preview-%s%s.tar.gz"):format(platform, arch)
  local release = run({
    "curl",
    "-sSfL",
    "https://api.github.com/repos/iamcco/markdown-preview.nvim/releases/tags/v" .. version,
  })
  local found = vim.iter(vim.json.decode(release).assets):find(function(a)
    return a.name == asset
  end)
  assert(found, "no release asset " .. asset)
  local tar, bin = vim.fn.tempname(), plugin.dir .. "/app/bin"
  run({ "curl", "-sSfL", "-H", "Accept: application/octet-stream", "-o", tar, found.url })
  vim.fn.mkdir(bin, "p")
  run({ "tar", "xzf", tar, "-C", bin })
  os.remove(tar)
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
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.icons" },
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
    cmd = { "MarkdownPreview", "MarkdownPreviewStop", "MarkdownPreviewToggle" },
    ft = "markdown",
    build = build_preview_server,
    init = function()
      vim.g.mkdp_auto_close = 0
    end,
    keys = {
      { "<leader>cp", ft = "markdown", "<cmd>MarkdownPreviewToggle<cr>", desc = "Markdown Preview" },
    },
  },
}
