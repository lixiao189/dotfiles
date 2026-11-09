local wezterm = require("wezterm")

local config = wezterm.config_builder()
local act = wezterm.action

-- CN 版内嵌 CJK 字形,中文显示不依赖系统回退;代价是每个字重约 20MB。
local FONT = "Maple Mono NF CN"

-- Re-evaluated on appearance changes, so this tracks light/dark live.
-- The mux server has no GUI process to ask, so it falls back to dark.
local appearance = wezterm.gui and wezterm.gui.get_appearance() or "Dark"
local dark = appearance:find("Dark") ~= nil

-- Catppuccin Mocha / Latte. Tab bar sits on mantle; the active tab uses surface0.
-- Only the colors that get overridden below are listed.
local MOCHA = {
	mantle = "#181825",
	surface0 = "#313244",
	surface1 = "#45475a",
	text = "#cdd6f4",
	subtext = "#a6adc8",
	overlay = "#6c7086",
	peach = "#fab387",
}

local LATTE = {
	mantle = "#e6e9ef",
	surface0 = "#ccd0da",
	surface1 = "#bcc0cc",
	text = "#4c4f69",
	subtext = "#6c6f85",
	overlay = "#9ca0b0",
	peach = "#fe640b",
}

local p = dark and MOCHA or LATTE

-- Performance
-- WebGpu is Metal on macOS; OpenGL (the default) is deprecated by Apple.
-- Delete this line to fall back to the default front end.
config.front_end = "WebGpu"
config.max_fps = 120
config.animation_fps = 1
config.unicode_version = 15

-- Font. Type scale: 14 for the terminal and its overlays, 12 for window chrome.
config.font = wezterm.font(FONT)
config.font_size = 14
config.line_height = 1.05
-- Ligatures reshape the current line on every keystroke.
config.harfbuzz_features = { "calt=0", "clig=0", "liga=0" }

-- Theme
config.color_scheme = dark and "Catppuccin Mocha" or "Catppuccin Latte"
config.command_palette_bg_color = p.mantle
config.command_palette_fg_color = p.text
config.command_palette_font_size = 14
config.char_select_bg_color = p.mantle
config.char_select_fg_color = p.text
config.colors = {
	split = p.surface1,
	compose_cursor = p.peach,
	-- Fancy tab bar paints each tab bg twice, so translucent colors stack unevenly.
	tab_bar = {
		background = p.mantle,
		inactive_tab_edge = p.mantle,
		active_tab = { bg_color = p.surface0, fg_color = p.text, intensity = "Bold" },
		inactive_tab = { bg_color = p.mantle, fg_color = p.overlay },
		inactive_tab_hover = { bg_color = p.surface0, fg_color = p.subtext },
	},
}
config.inactive_pane_hsb = { saturation = 0.9, brightness = dark and 0.75 or 0.95 }
config.default_cursor_style = "SteadyBlock"
config.cursor_blink_rate = 0 -- ignore app blink requests
-- Bar/underline cursors (e.g. vim insert) default to ~1px.
config.cursor_thickness = "1pt"

-- Window config
config.initial_rows = 28
config.initial_cols = 90
-- Symmetric: equal left/right, equal top/bottom (the default is 1 cell
-- horizontally and half a cell vertically).
config.window_padding = { left = 12, right = 12, top = 8, bottom = 8 }
-- Opacity < 1 normally turns the window shadow off; this flag forces it back on.
config.window_decorations = "TITLE|RESIZE|MACOS_FORCE_ENABLE_SHADOW"
config.window_frame = {
	font = wezterm.font({ family = FONT, weight = "Medium" }),
	font_size = 12,
	-- Painted again on nested groups, so any alpha stacks into darker blocks.
	active_titlebar_bg = p.mantle,
	inactive_titlebar_bg = p.mantle,
	border_left_width = 0,
	border_right_width = 0,
	border_top_height = 0,
	border_bottom_height = 0,
}
-- Light mode needs more opacity to keep contrast on the blur.
config.window_background_opacity = dark and 0.82 or 0.88
-- 20 is the radius the docs demo; beyond that the extra blur is invisible at
-- this opacity but still costs compositing.
config.macos_window_background_blur = 20
-- 1.0 keeps app-painted cell backgrounds fully opaque. The blur shows through
-- the default background (Neovim is transparent via catppuccin's
-- transparent_background) and through the window padding.
config.text_background_opacity = 1.0
-- Fullscreen stays non-native (default): instant, no Space animation. Set
-- native_macos_fullscreen_mode = true if you want a dedicated Space instead.
config.adjust_window_size_when_changing_font_size = false

-- Tabbar
config.hide_tab_bar_if_only_one_tab = true
config.show_new_tab_button_in_tab_bar = false

-- General
config.quit_when_all_windows_are_closed = false
config.audible_bell = "Disabled"
-- 10k is what Alacritty and Ghostty ship; wezterm's default is 3.5k. Memory and
-- reflow-on-resize both scale with this.
config.scrollback_lines = 10000
config.quick_select_remove_styling = true

-- Key bindings
-- Keys are lowercase and modifiers always spell out SHIFT: an uppercase key
-- ("K") implies SHIFT, so two entries can collide silently; the later wins.
config.keys = {
	-- Panes
	{ key = "d", mods = "SUPER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "d", mods = "SUPER|SHIFT", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "w", mods = "SUPER|SHIFT", action = act.CloseCurrentPane({ confirm = true }) },
	{ key = "z", mods = "SUPER", action = act.TogglePaneZoomState },
	{ key = "h", mods = "SUPER|ALT", action = act.ActivatePaneDirection("Left") },
	{ key = "j", mods = "SUPER|ALT", action = act.ActivatePaneDirection("Down") },
	{ key = "k", mods = "SUPER|ALT", action = act.ActivatePaneDirection("Up") },
	{ key = "l", mods = "SUPER|ALT", action = act.ActivatePaneDirection("Right") },
	{ key = "h", mods = "SUPER|SHIFT", action = act.AdjustPaneSize({ "Left", 3 }) },
	{ key = "j", mods = "SUPER|SHIFT", action = act.AdjustPaneSize({ "Down", 2 }) },
	{ key = "k", mods = "SUPER|SHIFT", action = act.AdjustPaneSize({ "Up", 2 }) },
	{ key = "l", mods = "SUPER|SHIFT", action = act.AdjustPaneSize({ "Right", 3 }) },

	-- Tabs and windows
	{ key = "[", mods = "SUPER", action = act.ActivateTabRelative(-1) },
	{ key = "]", mods = "SUPER", action = act.ActivateTabRelative(1) },
	{ key = "Enter", mods = "SUPER", action = act.ToggleFullScreen },

	-- Scrollback, palette, copy mode. QuickSelect stays on the default
	-- CTRL|SHIFT+Space; SUPER+Space belongs to Spotlight.
	{ key = "k", mods = "SUPER", action = act.ClearScrollback("ScrollbackAndViewport") },
	{ key = "p", mods = "SUPER|SHIFT", action = act.ActivateCommandPalette },
	{ key = "c", mods = "SUPER|SHIFT", action = act.ActivateCopyMode },
}

return config
