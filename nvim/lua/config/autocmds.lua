vim.api.nvim_create_autocmd("BufEnter", {
    pattern = {
        "*.cpp", "*.c", "*.h", "*.hpp",
        "*.vue", "*.js", "*.html", "*.css", "json"
    },
    callback = function()
        vim.opt.shiftwidth = 2
        vim.opt.tabstop = 2
        vim.opt.softtabstop = 2
    end
})
