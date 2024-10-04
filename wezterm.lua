-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- Theme for wezterm
config.color_scheme = 'Catppuccin Macchiato'

-- Window size
config.initial_cols = 90
config.initial_rows = 28

-- Font settings
config.font = wezterm.font("JetBrainsMono Nerd Font Mono")
config.font_size = 15
config.line_height = 1.2

-- Tab bar settings
config.hide_tab_bar_if_only_one_tab = true

-- FPS settings
config.max_fps = 255

-- and finally, return the configuration to wezterm
return config
