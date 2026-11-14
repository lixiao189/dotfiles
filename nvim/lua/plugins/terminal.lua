local util = require("config.util")

---@type table<integer, table>
local terminals = {}

---@param count integer
---@param dir fun():string
local function toggle_terminal(count, dir)
  return function()
    local Terminal = require("toggleterm.terminal").Terminal
    terminals[count] = terminals[count]
      or Terminal:new({ count = count, direction = "float", hidden = true })
    terminals[count].dir = dir()
    terminals[count]:toggle()
  end
end

return {
  {
    "akinsho/toggleterm.nvim",
    cmd = { "ToggleTerm", "TermExec" },
    keys = {
      { "<leader>ft", toggle_terminal(1, util.root), desc = "Terminal (Root Dir)" },
      { "<leader>fT", toggle_terminal(2, vim.uv.cwd), desc = "Terminal (cwd)" },
      { "<c-/>", toggle_terminal(1, util.root), mode = { "n", "t" }, desc = "Terminal (Root Dir)" },
      { "<c-_>", toggle_terminal(1, util.root), mode = { "n", "t" }, desc = "which_key_ignore" },
    },
    opts = {
      direction = "float",
      start_in_insert = true,
      persist_size = true,
      persist_mode = true,
      close_on_exit = false,
      shade_terminals = false,
      float_opts = { border = "single" },
    },
  },
}
