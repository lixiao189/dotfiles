local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- UI
config.initial_rows = 28
config.font = wezterm.font("JetBrainsMono Nerd Font Mono")
config.initial_cols = 90
config.font_size = 14
config.hide_tab_bar_if_only_one_tab = true
config.max_fps = 120

-- General
config.adjust_window_size_when_changing_font_size = false
config.quit_when_all_windows_are_closed = false

return config
