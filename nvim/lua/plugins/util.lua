local ai_buffer = function(ai_type)
  local start_line, end_line = 1, vim.fn.line "$"
  if ai_type == "i" then
    -- Skip first and last blank lines for `i` textobject
    local first_nonblank, last_nonblank = vim.fn.nextnonblank(start_line), vim.fn.prevnonblank(end_line)
    -- Do nothing for buffer with all blanks
    if first_nonblank == 0 or last_nonblank == 0 then return { from = { line = start_line, col = 1 } } end
    start_line, end_line = first_nonblank, last_nonblank
  end

  local to_col = math.max(vim.fn.getline(end_line):len(), 1)
  return { from = { line = start_line, col = 1 }, to = { line = end_line, col = to_col } }
end

return {
  {
    "echasnovski/mini.ai",
    opts = {
      custom_textobjects = {
        g = ai_buffer, -- Buffer
      },
    },
  },
}
