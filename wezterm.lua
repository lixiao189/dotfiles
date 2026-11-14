local wezterm = require("wezterm")

local config = wezterm.config_builder()
local act = wezterm.action

local FONT = "Maple Mono NF CN"

-- Re-evaluated on appearance changes. The mux server has no GUI to ask, so it falls back to dark.
local appearance = wezterm.gui and wezterm.gui.get_appearance() or "Dark"
local dark = appearance:find("Dark") ~= nil

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
-- WebGpu is Metal on macOS; the OpenGL default is deprecated by Apple.
config.front_end = "WebGpu"
config.max_fps = 120
config.animation_fps = 1
config.unicode_version = 15

-- Font
config.font = wezterm.font(FONT)
config.font_size = 14
config.line_height = 1.05
config.harfbuzz_features = { "calt=0", "clig=0", "liga=0" }

-- Theme
config.color_scheme = dark and "Catppuccin Mocha" or "Catppuccin Latte"
config.command_palette_bg_color = p.mantle
config.command_palette_fg_color = p.text
config.command_palette_font_size = config.font_size
config.char_select_bg_color = p.mantle
config.char_select_fg_color = p.text
config.char_select_font_size = config.font_size
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
-- Bar/underline cursors (vim insert) default to ~1px.
config.cursor_thickness = "1pt"

-- Window
config.initial_rows = 28
config.initial_cols = 90
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
-- Larger radii are invisible at this opacity but still cost compositing.
config.macos_window_background_blur = 20
config.adjust_window_size_when_changing_font_size = false

-- Tab bar
config.hide_tab_bar_if_only_one_tab = true
config.show_new_tab_button_in_tab_bar = false
config.switch_to_last_active_tab_when_closing_tab = true

-- General
config.quit_when_all_windows_are_closed = false
config.audible_bell = "Disabled"
config.scrollback_lines = 10000
config.quick_select_remove_styling = true

-- Key bindings
-- Keys stay lowercase with SHIFT spelled out: "K" implies SHIFT, and colliding entries
-- silently let the later one win.
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

	-- Scrollback, palette, copy mode. QuickSelect keeps CTRL|SHIFT+Space (SUPER+Space is Spotlight).
	-- CTRL+L makes the shell redraw the prompt the clear wiped.
	{
		key = "k",
		mods = "SUPER",
		action = act.Multiple({
			act.ClearScrollback("ScrollbackAndViewport"),
			act.SendKey({ key = "l", mods = "CTRL" }),
		}),
	},
	{ key = "p", mods = "SUPER|SHIFT", action = act.ActivateCommandPalette },
	{ key = "c", mods = "SUPER|SHIFT", action = act.ActivateCopyMode },
}

-- Mouse: links open on SUPER+click only. Unlisted defaults still apply.
config.mouse_bindings = {
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "NONE",
		action = act.CompleteSelection("ClipboardAndPrimarySelection"),
	},
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "SUPER",
		action = act.OpenLinkAtMouseCursor,
	},
	-- Keep the press from reaching apps with mouse reporting.
	{ event = { Down = { streak = 1, button = "Left" } }, mods = "SUPER", action = act.Nop },
}

return config
