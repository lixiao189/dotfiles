local ensure_installed = {
  "bash",
  "c",
  "cpp",
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
  "printf",
  "python",
  "query",
  "regex",
  "rust",
  "toml",
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
  "xml",
  "yaml",
}
local ts = require("nvim-treesitter")
local installed = {}
for _, lang in ipairs(ts.get_installed()) do
  installed[lang] = true
end
local missing = vim.tbl_filter(function(lang)
  return not installed[lang]
end, ensure_installed)
if #missing > 0 then
  ts.install(missing)
end

local available ---@type table<string, boolean>?
local function is_available(lang)
  if not available then
    available = {}
    for _, l in ipairs(ts.get_available()) do
      available[l] = true
    end
  end
  return available[lang]
end

---@param buf integer
---@param lang string
local function attach(buf, lang)
  if not vim.api.nvim_buf_is_valid(buf) or not vim.treesitter.language.add(lang) then
    return
  end
  vim.treesitter.start(buf, lang)
  for _, win in ipairs(vim.fn.win_findbuf(buf)) do
    vim.wo[win][0].foldmethod = "expr"
    vim.wo[win][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
  end
  if vim.treesitter.query.get(lang, "indents") then
    vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end
end

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("config_treesitter", { clear = true }),
  callback = function(ev)
    local lang = vim.treesitter.language.get_lang(ev.match)
    if not lang or vim.bo[ev.buf].buftype ~= "" then
      return
    end
    if vim.treesitter.language.add(lang) then
      attach(ev.buf, lang)
    elseif is_available(lang) then
      ts.install(lang):await(function()
        vim.schedule(function()
          attach(ev.buf, lang)
        end)
      end)
    end
  end,
})
