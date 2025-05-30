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
          ["<A-j>"] = { "<cmd>execute 'move .+' . v:count1<cr>==", desc = "Move Down" },
          ["<A-k>"] = { "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", desc = "Move Up" },
        },
        i = {
          ["<A-j>"] = { "<esc><cmd>m .+1<cr>==gi", desc = "Move Down" },
          ["<A-k>"] = { "<esc><cmd>m .-2<cr>==gi", desc = "Move Up" },
        },
        v = {
          ["<A-j>"] = { ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", desc = "Move Down" },
          ["<A-k>"] = { ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", desc = "Move Up" },
        },
      },
    },
  },
}
