-- Global statusline on mini.statusline: plain coloured text on a transparent bar
-- (mode, branch, diff, file | diagnostics, LSP, filetype, position).
local statusline = require("mini.statusline")

local modes = {
  n = { "NORMAL", "Normal" },
  no = { "O-PENDING", "Normal" },
  v = { "VISUAL", "Visual" },
  V = { "V-LINE", "Visual" },
  ["\22"] = { "V-BLOCK", "Visual" },
  s = { "SELECT", "Visual" },
  S = { "S-LINE", "Visual" },
  ["\19"] = { "S-BLOCK", "Visual" },
  i = { "INSERT", "Insert" },
  R = { "REPLACE", "Replace" },
  c = { "COMMAND", "Command" },
  r = { "PROMPT", "Command" },
  ["!"] = { "SHELL", "Terminal" },
  t = { "TERMINAL", "Terminal" },
}

local function hl(group, text)
  return ("%%#%s#%s"):format(group, text)
end

local function git()
  local status = vim.b.gitsigns_status_dict
  if not status or not status.head or status.head == "" then
    return ""
  end
  local parts = { hl("StlBranch", "\u{e725} " .. status.head) }
  for _, d in ipairs({
    { "added", "+", "StlAdded" },
    { "changed", "~", "StlChanged" },
    { "removed", "-", "StlRemoved" },
  }) do
    if (status[d[1]] or 0) > 0 then
      parts[#parts + 1] = hl(d[3], d[2] .. status[d[1]])
    end
  end
  return table.concat(parts, " ")
end

local special = {
  snacks_picker_list = "\u{f07c} Explorer",
  snacks_picker_input = "\u{f002} Search",
  snacks_dashboard = "\u{f015} Dashboard",
  snacks_terminal = "\u{f120} Terminal",
  ["grug-far"] = "\u{f002} Search & Replace",
  qf = "\u{f0ae} Quickfix",
  help = "\u{f059} Help",
}

local function filename()
  local buf = vim.api.nvim_get_current_buf()
  local ft = vim.bo[buf].filetype
  if special[ft] or vim.bo[buf].buftype ~= "" then
    return hl("StlFile", special[ft] or (ft ~= "" and ft or vim.bo[buf].buftype))
  end
  local name = vim.api.nvim_buf_get_name(buf)
  if name == "" then
    return hl("StlFile", "[No Name]")
  end
  local path = vim.fn.fnamemodify(name, ":~:.")
  local dir, tail = path:match("^(.*/)([^/]+)$")
  local ret = (dir and not statusline.is_truncated(100)) and hl("StlDir", dir) or ""
  ret = ret .. hl("StlFile", tail or path)
  if vim.bo[buf].modified then
    ret = ret .. hl("StlModified", " \u{25cf}")
  elseif vim.bo[buf].readonly or not vim.bo[buf].modifiable then
    ret = ret .. hl("StlDir", " \u{f023}")
  end
  return ret
end

local function diagnostics()
  local count = vim.diagnostic.count(0)
  local parts = {}
  local signs = { "\u{f057} ", "\u{f071} ", "\u{f05a} ", "\u{f0eb} " }
  local groups = { "DiagnosticError", "DiagnosticWarn", "DiagnosticInfo", "DiagnosticHint" }
  for severity = 1, 4 do
    if (count[severity] or 0) > 0 then
      parts[#parts + 1] = hl("Stl" .. groups[severity], signs[severity] .. count[severity])
    end
  end
  return table.concat(parts, " ")
end

local function lsp()
  local names = vim.tbl_map(function(c)
    return c.name
  end, vim.lsp.get_clients({ bufnr = 0 }))
  return #names > 0 and hl("StlMuted", "\u{f085} " .. table.concat(names, ", ")) or ""
end

local function filetype()
  local ft = vim.bo.filetype
  if ft == "" or vim.bo.buftype ~= "" then
    return ""
  end
  local icon, icon_hl = MiniIcons.get("filetype", ft)
  return hl(icon_hl, icon) .. " " .. hl("StlMuted", ft)
end

local function join(parts)
  return table.concat(
    vim.tbl_filter(function(p)
      return p ~= ""
    end, parts),
    "  "
  )
end

statusline.setup({
  content = {
    active = function()
      local mode = modes[vim.fn.mode()] or modes[vim.fn.mode():sub(1, 1)] or modes.n
      local wide = not statusline.is_truncated(80)
      local left = join({ hl("StlMode" .. mode[2], mode[1]), wide and git() or "", filename() })
      local right = join({
        diagnostics(),
        wide and lsp() or "",
        wide and filetype() or "",
        hl("StlMuted", "%l:%c  %P"),
      })
      return hl("StatusLine", " ") .. left .. hl("StatusLine", "%<%=") .. right .. hl("StatusLine", " ")
    end,
    inactive = function()
      return hl("StatusLineNC", " %f%=")
    end,
  },
})

local function set_highlights()
  local ok, palettes = pcall(require, "catppuccin.palettes")
  if not ok or not (vim.g.colors_name or ""):find("^catppuccin") then
    return
  end
  local c = palettes.get_palette()
  local bar = "NONE" -- let the terminal's translucent background show through
  local set = vim.api.nvim_set_hl
  set(0, "StatusLine", { fg = c.text, bg = bar })
  set(0, "StatusLineNC", { fg = c.overlay0, bg = bar })
  for name, color in pairs({
    Normal = c.blue,
    Insert = c.green,
    Visual = c.mauve,
    Replace = c.red,
    Command = c.peach,
    Terminal = c.teal,
  }) do
    set(0, "StlMode" .. name, { fg = color, bg = bar, bold = true })
  end
  set(0, "StlBranch", { fg = c.mauve, bg = bar, bold = true })
  set(0, "StlAdded", { fg = c.green, bg = bar })
  set(0, "StlChanged", { fg = c.yellow, bg = bar })
  set(0, "StlRemoved", { fg = c.red, bg = bar })
  set(0, "StlDir", { fg = c.overlay1, bg = bar })
  set(0, "StlFile", { fg = c.text, bg = bar, bold = true })
  set(0, "StlModified", { fg = c.peach, bg = bar })
  set(0, "StlMuted", { fg = c.overlay1, bg = bar })
  set(0, "StlDiagnosticError", { fg = c.red, bg = bar })
  set(0, "StlDiagnosticWarn", { fg = c.yellow, bg = bar })
  set(0, "StlDiagnosticInfo", { fg = c.sky, bg = bar })
  set(0, "StlDiagnosticHint", { fg = c.teal, bg = bar })
  set(0, "StlExplorerHeader", { fg = c.subtext0, bold = true })
end

set_highlights()
vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("config_statusline", { clear = true }),
  callback = set_highlights,
})
-- Redraw on git/diagnostic/LSP changes so the bar never lags.
vim.api.nvim_create_autocmd({ "DiagnosticChanged", "LspAttach", "LspDetach", "User" }, {
  group = "config_statusline",
  callback = function(ev)
    if ev.event ~= "User" or ev.match == "GitSignsUpdate" then
      vim.cmd.redrawstatus()
    end
  end,
})
