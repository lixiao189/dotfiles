return {
    'phaazon/hop.nvim',
    branch = 'v2', -- optional but strongly recommended
    config = function()
        require('hop').setup()
        local hop = require('hop')
        vim.keymap.set({ 'n', 'v' }, 'S', function()
            hop.hint_char1()
        end, { remap = true })
        vim.keymap.set({ 'n', 'v' }, "L", function()
            hop.hint_lines()
        end, { remap = true })
    end
}
