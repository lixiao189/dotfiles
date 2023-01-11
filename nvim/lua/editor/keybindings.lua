local function map(mode, lhs, rhs)
    vim.api.nvim_set_keymap(mode, lhs, rhs, { noremap = true, silent = true })
end

-- Moving to beginning and the end
map("n", "L", "$")
map("n", "H", "^")
map("v", "L", "$")
map("v", "H", "^")

-- Use Ctrl + c to stop highlighting
map("n", "<C-c>", "<CMD>noh<CR>")

map("n", "<A-Down>", ":resize -2<CR>")
map("n", "<A-Up>", ":resize +2<CR>")
map("n", "<A-Left>", ":vertical resize -2<CR>")
map("n", "<A-Right>", ":vertical resize +2<CR>")

map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

map("v", "<<", "<gv");
map("v", ">>", ">gv");

-- Keybingdings for toggle_terminal plugin
map("t", '<esc>', [[<C-\><C-n>]])
map('t', '<C-h>', [[<C-\><C-n><C-W>h]])
map('t', '<C-j>', [[<C-\><C-n><C-W>j]])
map('t', '<C-k>', [[<C-\><C-n><C-W>k]])
map('t', '<C-l>', [[<C-\><C-n><C-W>l]])

-- Preview quickfix item in split view
vim.cmd [[ autocmd! FileType qf nnoremap <buffer> <leader><Enter> <C-w><Enter><C-w>L ]]

local wk = require("which-key")
wk.register {
    ["[b"] = { "<cmd>BufferLineCyclePrev<CR>", "Previous buffer" },
    ["]b"] = { "<cmd>BufferLineCycleNext<CR>", "Next buffer", },
}
wk.register({
    w = { ":w<cr>", "Save the file" },
    q = { ":q<cr>", "Quit the window" },
    m = { ":NvimTreeToggle<CR>", "Toggle file manager" },
    r = { ":!sh run.sh<cr>", "Run code with run.sh" },
    v = { ":vertical split<CR>", "Vertical split the window" },
    s = { ":split<CR>", "Split the window" },
    t = {
        name = "+tags",
        s = { ":GscopeFind s <C-R><C-W><cr>", "Find symbol (reference) under cursor" },
        d = { ":GscopeFind g <C-R><C-W><cr>", "Find symbol definition under cursor" },
        a = { ":GscopeFind a <C-R><C-W><cr>", "Find symbol assignments" },
        c = { ":GscopeFind c <C-R><C-W><cr>", "Functions calling this function" },
        C = { ":GscopeFind d <C-R><C-W><cr>", "Functions called by this function" }
    },
    f = {
        name = "+find",
        m = { ":NvimTreeFindFile<CR>", "Show current file in file manager" },
        f = { "<cmd>Telescope find_files<cr>", "Find File" },
        o = { "<cmd>Telescope oldfiles<cr>", "Show recent old file" },
        r = { "<cmd>lua require('spectre').open()<cr>", "Find and replace" },
        g = { "<cmd>Telescope live_grep<cr>", "Search text globally" },
    },
    g = {
        name = "+git action",
        t = { "<cmd>LazyGit<cr>", "Show git tui" },

        p = { "<cmd>Gitsigns preview_hunk<CR>", "Preview the hunk changes" },
        d = { "<cmd>Gitsigns diffthis<CR>", "Show diff in this buffer" },
        s = { ":Gitsigns stage_hunk<CR>", "Stage hunk" },
        r = { ":Gitsigns reset_hunk<CR>", "Reset hunk" },
        S = { ":Gitsigns stage_buffer<CR>", "Stage buffer" },
        u = { ":Gitsigns undo_stage_hunk<CR>", "Undo stage" },
        R = { ":Gitsigns reset_buffer<CR>", "Reset buffer" },

        c = { ":GitConflictListQf<CR>", "List confilicts" },

        j = {
            name = "+jump hunk",
            p = { ":Gitsigns prev_hunk<CR>", "Previous change" },
            n = { ":Gitsigns next_hunk<CR>", "Next change" },
        }
    },
    b = {
        name = "+buffer",
        l = { "<Cmd>lua require('telescope.builtin').buffers()<CR>", "Show buffer list" },
        g = { "<Cmd>BufferLinePick<CR>", "Go to buffer" },
        c = { "<Cmd>BufferLinePickClose<CR>", "Close buffer" },
        d = { "<CMD>Bdelete<CR>", "Delete current buffer" }
    },
    c = {
        name = "+code",
        l = { ":LspStop<CR>", "Turn off LSP" },
        L = { ":LspStart<CR>", "Turn on LSP" },
        a = { ":lua vim.lsp.buf.code_action()<CR>", "Lsp Code action" },
        s = { ":SymbolsOutline<cr>", "Symbol outline" },
        k = { ":lua vim.lsp.buf.hover()<CR>", "Lsp document hover" },
        f = { ":lua vim.lsp.buf.format { async = true }<CR>", "Format the code" },
        r = { ":lua vim.lsp.buf.rename()<CR>", "Rename variable" },
        t = { ":TroubleToggle<cr>", "Show trouble" },
        d = { ":Telescope lsp_definitions<cr>", "Jump to defination" },
        D = { ":vsplit<CR>:Telescope lsp_definitions<cr>", "Jump to defination" },
        R = { ":Telescope lsp_references<cr>", "Show the references" },
    },
}, { prefix = "<leader>" })

wk.setup {
    layout = {
        align = "center",
    },
}
