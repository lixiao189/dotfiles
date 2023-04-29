return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v2.x",
  dependencies = {
    'nvim-tree/nvim-web-devicons',     -- for file icons
    "MunifTanjim/nui.nvim",
    { 's1n7ax/nvim-window-picker', version = "v1.*" }
  },
  config = function()
    require 'window-picker'.setup {
      autoselect_one = true,
      include_current = false,
      filter_rules = {
        -- filter using buffer options
        bo = {
          -- if the file type is one of following, the window will be ignored
          filetype = { 'neo-tree', "neo-tree-popup", "notify" },
          -- if the buffer type is one of following, the window will be ignored
          buftype = { 'terminal', "quickfix" },
        },
      },
      other_win_hl_color = '#e35e4f',
    }

    -- Icons defination
    vim.fn.sign_define("DiagnosticSignError",
      { text = " ", texthl = "DiagnosticSignError" })
    vim.fn.sign_define("DiagnosticSignWarn",
      { text = " ", texthl = "DiagnosticSignWarn" })
    vim.fn.sign_define("DiagnosticSignInfo",
      { text = " ", texthl = "DiagnosticSignInfo" })
    vim.fn.sign_define("DiagnosticSignHint",
      { text = " ", texthl = "DiagnosticSignHint" })

    require("neo-tree").setup {
      filesystem = {
        follow_current_file = true,
        use_libuv_file_watcher = true
      },
      window = {
        width = 30
      },
      event_handlers = {
        {
          event = "file_opened",
          handler = function(_)
            vim.o.signcolumn = "yes"
          end
        }
      }
    }
  end
}
