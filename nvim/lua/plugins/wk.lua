return {
    {
        'folke/which-key.nvim',
        config = function()
            local wk = require("which-key")
            wk.register {
                ["[b"] = { "<cmd>BufferLineCyclePrev<CR>", "Previous buffer" },
                ["]b"] = { "<cmd>BufferLineCycleNext<CR>", "Next buffer", },
            }
            wk.register({
                w = { ":w<cr>", "Save the file" },
                m = { ":Neotree toggle<CR>", "Toggle file manager" },
                r = { ":!sh run.sh<cr>", "Run code with run.sh" },
                v = { ":vertical split<CR>", "Vertical split the window" },
                s = { ":split<CR>", "Split the window" },
                t = {
                    name = "+tags",
                    g = { ":lua require'telescope.builtin'.tags()<CR>", "Find symbol globally" },
                    s = { ":GscopeFind s <C-R><C-W><cr>", "Find symbol (reference) under cursor" },
                    d = { ":GscopeFind g <C-R><C-W><cr>", "Find symbol definition under cursor" },
                    a = { ":GscopeFind a <C-R><C-W><cr>", "Find symbol assignments" },
                    c = { ":GscopeFind c <C-R><C-W><cr>", "Functions calling this function" },
                    C = { ":GscopeFind d <C-R><C-W><cr>", "Functions called by this function" }
                },
                f = {
                    name = "+find",
                    f = { "<cmd>Telescope find_files<cr>", "Find File" },
                    o = { "<cmd>Telescope oldfiles<cr>", "Show recent old file" },
                    r = { "<cmd>lua require('spectre').open()<cr>", "Find and replace" },
                    g = { "<cmd>Telescope live_grep<cr>", "Search text globally" },
                },
                g = {
                    name = "+git action",
                    t = { "<cmd>Neogit<cr>", "Show git tui" },

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
                    a = { ":Lspsaga code_action<CR>", "Lsp Code action" },
                    s = { ":Lspsaga outline<CR>", "Symbol outline" },
                    k = { ":Lspsaga hover_doc<CR>", "Lsp document hover" },
                    f = { ":lua vim.lsp.buf.format { async = true }<CR>", "Format the code" },
                    r = { ":Lspsaga rename<CR><CR>", "Rename variable" },
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
        end
    }
}
