-- empty setup using defaults: add your own options
require 'nvim-tree'.setup {
    diagnostics = {
        enable = true,
        show_on_dirs = true,
    },
    actions = {
        open_file = {
            quit_on_open = true,
        },
    },
    git = {
        ignore = false,
    },
    view = {
        hide_root_folder = true,
    }
}
