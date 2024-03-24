return {
    'phaazon/hop.nvim',
    branch = 'v2', -- optional but strongly recommended
    config = function()
        require('hop').setup()
        local hop = require('hop')
        local directions = require('hop.hint').HintDirection
        vim.keymap.set({ 'n', 'v' }, 'S', function()
            hop.hint_char1()
        end, { remap = true })
        vim.keymap.set({ 'n', 'v' }, "<leader><leader>j", function()
            hop.hint_lines_skip_whitespace({ direction = directions.AFTER_CURSOR })
        end, { remap = true })
        vim.keymap.set({ 'n', 'v' }, "<leader><leader>k", function()
            hop.hint_lines_skip_whitespace({ direction = directions.BEFORE_CURSOR })
        end, { remap = true })
    end
}
