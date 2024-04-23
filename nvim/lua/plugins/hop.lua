return {
    'phaazon/hop.nvim',
    branch = 'v2', -- optional but strongly recommended
    config = function()
        require('hop').setup()
        local hop = require('hop')
        vim.keymap.set({ 'n', 'v' }, 'gs', function()
            hop.hint_char1()
        end, { remap = true, silent = true, noremap = true, desc = "Go to char" })
        vim.keymap.set({ 'n', 'v' }, "gl", function()
            hop.hint_lines()
        end, { remap = true, silent = true, noremap = true, desc = "Go to line" })
    end
}
