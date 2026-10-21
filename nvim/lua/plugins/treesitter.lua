local ensure_installed = {
  "bash",
  "c",
  "cmake",
  "cpp",
  "css",
  "diff",
  "go",
  "html",
  "javascript",
  "jsdoc",
  "json",
  "lua",
  "luadoc",
  "markdown",
  "markdown_inline",
  "objc",
  "printf",
  "python",
  "query",
  "regex",
  "rust",
  "swift",
  "toml",
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
  "xml",
  "yaml",
  "zsh",
}
local ts = require("nvim-treesitter")
ts.install(ensure_installed)

local available = {}
for _, lang in ipairs(ts.get_available()) do
  available[lang] = true
end

---@param buf integer
---@param lang string
---@return boolean
local function attach(buf, lang)
  if not vim.api.nvim_buf_is_valid(buf) or not vim.treesitter.language.add(lang) then
    return false
  end
  vim.treesitter.start(buf, lang)
  for _, win in ipairs(vim.fn.win_findbuf(buf)) do
    vim.wo[win][0].foldmethod = "expr"
    vim.wo[win][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
  end
  if vim.treesitter.query.get(lang, "indents") then
    vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end
  return true
end

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("config_treesitter", { clear = true }),
  callback = function(ev)
    local lang = vim.treesitter.language.get_lang(ev.match)
    if not lang or vim.bo[ev.buf].buftype ~= "" or attach(ev.buf, lang) then
      return
    end
    if available[lang] then
      ts.install(lang):await(function()
        vim.schedule(function()
          attach(ev.buf, lang)
        end)
      end)
    end
  end,
})
