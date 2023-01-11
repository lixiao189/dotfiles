vim.g.indent_blankline_filetype_exclude = {
    "NvimTree",
    "lspinfo",
    "lspinstallinfo",
    "help",
    "checkhealth",
    "Outline",
    "dashboard",
    "packer",
}

require("indent_blankline").setup {
    -- for example, context is off by default, use this to turn it on
    show_current_context = true,
}
