vim.notify = require("notify")
require("notify").setup({
    background_colour = "#000000",
})
-- Enable telescope support
require("telescope").load_extension("notify")
