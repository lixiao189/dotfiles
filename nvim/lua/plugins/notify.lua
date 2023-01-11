require("notify").setup({
    -- For stages that change opacity this is treated as the highlight behind the window
    -- Set this to either a highlight group, an RGB hex value e.g. "#000000" or a function returning an RGB code for dynamic values
    background_colour = "#000000",
})

vim.notify = require("notify")

-- Enable telescope support
require("telescope").load_extension("notify")
