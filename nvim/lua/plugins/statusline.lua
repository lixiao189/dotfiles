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
  ["neo-tree"] = "\u{f07c} Explorer",
  dashboard = "\u{f015} Dashboard",
  toggleterm = "\u{f120} Terminal",
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
  local ret = (dir and not MiniStatusline.is_truncated(100)) and hl("StlDir", dir) or ""
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

-- vim.lsp.status() consumes the progress ring buffer, so the next redraw would be
-- empty. Cache work-done progress and keep it on the bar until the server says end.
local frames = {
  "\u{280b}",
  "\u{2819}",
  "\u{2839}",
  "\u{2838}",
  "\u{283c}",
  "\u{2834}",
  "\u{2826}",
  "\u{2827}",
  "\u{2807}",
  "\u{280f}",
}
local frame = 1
---@type table<integer, table<integer|string, {title: string, message: string?, percentage: number?}>>
local lsp_active = {}
local lsp_timer ---@type uv.uv_timer_t?

local function lsp_busy()
  for _, tokens in pairs(lsp_active) do
    if next(tokens) then
      return true
    end
  end
  return false
end

local function stop_lsp_timer()
  if not lsp_timer then
    return
  end
  lsp_timer:stop()
  lsp_timer:close()
  lsp_timer = nil
end

local function start_lsp_timer()
  if lsp_timer then
    return
  end
  lsp_timer = assert(vim.uv.new_timer())
  lsp_timer:start(
    100,
    100,
    vim.schedule_wrap(function()
      if not lsp_busy() then
        return stop_lsp_timer()
      end
      frame = frame % #frames + 1
      if vim.fn.mode() ~= "c" then
        vim.cmd.redrawstatus()
      end
    end)
  )
end

local function shorten(text, max)
  if vim.fn.strdisplaywidth(text) <= max then
    return text
  end
  local n = math.min(vim.fn.strchars(text), max)
  while n > 0 and vim.fn.strdisplaywidth(vim.fn.strcharpart(text, 0, n)) > max - 1 do
    n = n - 1
  end
  return vim.fn.strcharpart(text, 0, n) .. "\u{2026}"
end

local function lsp_progress()
  local ids = {}
  for client_id in pairs(lsp_active) do
    ids[#ids + 1] = client_id
  end
  table.sort(ids)
  local parts = {}
  for _, client_id in ipairs(ids) do
    local client = vim.lsp.get_client_by_id(client_id)
    local tokens = lsp_active[client_id]
    if not client or not tokens then
      lsp_active[client_id] = nil
    else
      local items = {}
      for _, item in pairs(tokens) do
        items[#items + 1] = item
      end
      table.sort(items, function(a, b)
        if a.title ~= b.title then
          return a.title < b.title
        end
        return (a.message or "") < (b.message or "")
      end)
      for _, item in ipairs(items) do
        local bits = { frames[frame], client.name }
        if item.title ~= "" then
          bits[#bits + 1] = item.title:gsub("%s+", " ")
        end
        if type(item.percentage) == "number" then
          bits[#bits + 1] = string.format("%d%%", item.percentage)
        end
        if item.message and item.message ~= "" and item.message ~= item.title then
          bits[#bits + 1] = item.message:gsub("%s+", " ")
        end
        parts[#parts + 1] = table.concat(bits, " ")
      end
    end
  end
  if not lsp_busy() then
    stop_lsp_timer()
  end
  if #parts == 0 then
    return ""
  end
  local text = shorten(table.concat(parts, "  "), math.floor(vim.o.columns / 3))
  return hl("StlProgress", (text:gsub("%%", "%%%%")))
end

local function on_lsp_progress(ev)
  local value = vim.tbl_get(ev, "data", "params", "value")
  if type(value) ~= "table" or not value.kind then
    return
  end
  local client_id = ev.data.client_id
  local token = ev.data.params.token
  local tokens = lsp_active[client_id] or {}
  lsp_active[client_id] = tokens
  if value.kind == "end" then
    tokens[token] = nil
    if not next(tokens) then
      lsp_active[client_id] = nil
    end
    if not lsp_busy() then
      stop_lsp_timer()
    end
  else
    local prev = tokens[token]
    local item = {
      title = value.title or (prev and prev.title) or "",
      message = value.message,
      percentage = value.percentage,
    }
    if value.kind == "report" and prev then
      if item.message == nil then
        item.message = prev.message
      end
      if item.percentage == nil then
        item.percentage = prev.percentage
      end
    end
    tokens[token] = item
    start_lsp_timer()
  end
  vim.cmd.redrawstatus()
end

local function lsp()
  local names = {}
  for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
    if not lsp_active[client.id] then
      names[#names + 1] = client.name
    end
  end
  return #names > 0 and hl("StlMuted", "\u{f085} " .. table.concat(names, ", ")) or ""
end

local function filetype()
  local ft = vim.bo.filetype
  if ft == "" or vim.bo.buftype ~= "" then
    return ""
  end
  local icon, icon_hl = require("mini.icons").get("filetype", ft)
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

return {
  "nvim-mini/mini.statusline",
  lazy = false,
  config = function()
    require("mini.statusline").setup({
      content = {
        active = function()
          local mode = modes[vim.fn.mode()] or modes[vim.fn.mode():sub(1, 1)] or modes.n
          local wide = not MiniStatusline.is_truncated(80)
          local left = join({ hl("StlMode" .. mode[2], mode[1]), wide and git() or "", filename() })
          local right = join({
            diagnostics(),
            lsp_progress(),
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
      set(0, "StlProgress", { fg = c.sapphire, bg = bar })
      set(0, "StlExplorerHeader", { fg = c.subtext0, bold = true })
    end

    set_highlights()
    vim.api.nvim_create_autocmd("ColorScheme", {
      group = vim.api.nvim_create_augroup("config_statusline", { clear = true }),
      callback = set_highlights,
    })
    local function redrawstatus()
      vim.cmd.redrawstatus()
    end
    vim.api.nvim_create_autocmd({ "DiagnosticChanged", "LspAttach", "LspDetach" }, {
      group = "config_statusline",
      callback = redrawstatus,
    })
    vim.api.nvim_create_autocmd("User", {
      group = "config_statusline",
      pattern = "GitSignsUpdate",
      callback = redrawstatus,
    })
    vim.api.nvim_create_autocmd("LspProgress", {
      group = "config_statusline",
      callback = on_lsp_progress,
    })
    vim.api.nvim_create_autocmd("VimLeavePre", {
      group = "config_statusline",
      callback = stop_lsp_timer,
    })
  end,
}
