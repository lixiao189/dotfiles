return {
  {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
      options = {
        opt = {
          clipboard = "",
        },
      },
      mappings = {
        -- first key is the mode
        n = {
          ["<S-h>"] = { "<cmd>bprevious<cr>", desc = "Prev Buffer" },
          ["<S-l>"] = { "<cmd>bnext<cr>", desc = "Next Buffer" },
        },
      },
    },
  },
}
