vim.api.nvim_create_autocmd("BufEnter", {
    pattern = {
        "*.c", "*.h", "*.hpp", "*.cpp", "*.cc",
        "*.vue", "*.js", "*.jsx", "*.html", "*.css", "*.json", "*.ts", "*.tsx", "*.less",
    },
    callback = function()
        vim.opt.shiftwidth = 2
        vim.opt.tabstop = 2
        vim.opt.softtabstop = 2
    end
})

vim.api.nvim_create_autocmd("BufEnter", {
    pattern = {
        "*.lua", "*.go", "*.java", "*.py", "*.xml"
    },
    callback = function()
        vim.opt.shiftwidth = 4
        vim.opt.tabstop = 4
        vim.opt.softtabstop = 4
    end
})
