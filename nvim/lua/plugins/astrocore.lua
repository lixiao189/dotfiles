---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    -- vim options can be configured here
    options = {
      opt = { -- vim.opt.<key>
        updatetime = 100,
        clipboard = "",
        fileencodings = "utf-8,gbk",
      },
      g = { -- vim.g.<key>
        -- configure global vim variables (vim.g)
      },
    },
    mappings = {
      n = {
        ["<S-l>"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
        ["<S-h>"] = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },
      },
    },
  },
}
