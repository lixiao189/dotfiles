return {
  'nvim-treesitter/nvim-treesitter',
  run = ':TSUpdate',
  init = function()
    vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
    vim.o.foldlevelstart = 99
    vim.wo.foldmethod = 'expr'
    vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
  end,
  config = function()
    require('nvim-treesitter.configs').setup {
      ensure_installed = { "lua", "markdown", "markdown_inline", "swift" },
      highlight = {
        enable = false,
        additional_vim_regex_highlighting = false,
      },
      indent = {
        enable = true,
        -- disable = { "swift" }
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "gnn",
          node_incremental = "grn",
          scope_incremental = "grc",
          node_decremental = "grm",
        },
      },
    }
  end,
}
