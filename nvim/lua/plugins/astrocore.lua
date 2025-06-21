---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    -- vim options can be configured here
    options = {
      opt = { -- vim.opt.<key>
        clipboard = "",
      },
      g = { -- vim.g.<key>
        -- configure global vim variables (vim.g)
      },
    },
  },
}
