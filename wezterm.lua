local wezterm = require("wezterm")

local config = wezterm.config_builder()
local act = wezterm.action

-- Re-evaluated on appearance changes, so this tracks light/dark live.
local dark = not wezterm.gui or wezterm.gui.get_appearance():find("Dark") ~= nil

-- Catppuccin Latte / Mocha. Tab bar sits on mantle; the active tab uses surface0.
local p = dark
		and {
			base = "#1e1e2e",
			mantle = "#181825",
			crust = "#11111b",
			surface0 = "#313244",
			surface1 = "#45475a",
			text = "#cdd6f4",
			subtext = "#a6adc8",
			overlay = "#6c7086",
			accent = "#cba6f7",
			peach = "#fab387",
		}
	or {
		base = "#eff1f5",
		mantle = "#e6e9ef",
		crust = "#dce0e8",
		surface0 = "#ccd0da",
		surface1 = "#bcc0cc",
		text = "#4c4f69",
		subtext = "#6c6f85",
		overlay = "#9ca0b0",
		accent = "#8839ef",
		peach = "#fe640b",
	}

-- Light mode needs more opacity to keep contrast on the blur.
local OPACITY = dark and 0.82 or 0.88
local BLUR = 40

-- WebGpu uses Metal on macOS. Nothing animates, so animation_fps stays minimal.
config.front_end = "WebGpu"
config.max_fps = 120
config.animation_fps = 1
config.unicode_version = 15
-- Don't batch output for 3ms; it delays every keystroke echo.
config.mux_output_parser_coalesce_delay_ms = 0

-- Latin + CJK + Nerd Font icons, same face Ghostty uses.
config.font_size = 14
config.line_height = 1.05
config.font = wezterm.font_with_fallback({
	{ family = "Maple Mono NF CN", weight = "Regular" },
	{ family = "PingFang SC", weight = "Regular" },
	"Apple Color Emoji",
})
config.bold_brightens_ansi_colors = "BrightAndBold"
config.anti_alias_custom_block_glyphs = true

-- Latte in light mode, Mocha in dark mode.
config.color_scheme = dark and "Catppuccin Mocha" or "Catppuccin Latte"
config.command_palette_bg_color = p.mantle
config.command_palette_fg_color = p.text
config.command_palette_font_size = 15
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

-- TITLE|RESIZE is the native macOS titlebar. RESIZE alone drops it;
-- INTEGRATED_BUTTONS draws the traffic lights inside the tab bar.
config.initial_rows = 28
config.initial_cols = 90
config.window_padding = { left = 12, right = 12, top = 8, bottom = 4 }
config.window_decorations = "TITLE|RESIZE|MACOS_FORCE_ENABLE_SHADOW"
config.window_frame = {
	font = wezterm.font({ family = "Maple Mono NF CN", weight = "Medium" }),
	font_size = 12,
	-- Painted again on nested groups, so any alpha stacks into darker blocks.
	active_titlebar_bg = p.mantle,
	inactive_titlebar_bg = p.mantle,
	border_left_width = 0,
	border_right_width = 0,
	border_top_height = 0,
	border_bottom_height = 0,
}
config.window_background_opacity = OPACITY
config.macos_window_background_blur = BLUR
-- App-painted cell backgrounds (Neovim Normal, prompts) stay at window opacity.
config.text_background_opacity = 1.0
config.native_macos_fullscreen_mode = true
config.adjust_window_size_when_changing_font_size = false

-- Traffic lights are in the native titlebar, so a lone tab can hide.
config.use_fancy_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.show_new_tab_button_in_tab_bar = false
-- Status only shows a non-default workspace.
config.status_update_interval = 2000

config.quit_when_all_windows_are_closed = false
config.audible_bell = "Disabled"
config.scrollback_lines = 20000
config.enable_scroll_bar = false
config.bypass_mouse_reporting_modifiers = "SHIFT"
config.quick_select_remove_styling = true
config.skip_close_confirmation_for_processes_named = {
	"bash",
	"sh",
	"zsh",
	"fish",
	"tmux",
	"nu",
	"cmd.exe",
	"pwsh.exe",
	"powershell.exe",
}

-- SUPER so Neovim/shell bindings stay intact. Unset keys keep WezTerm defaults.
config.keys = {
	{ key = "k", mods = "SUPER", action = act.ClearScrollback("ScrollbackAndViewport") },
	{ key = "K", mods = "SUPER", action = act.ClearScrollback("ScrollbackOnly") },
	{ key = "P", mods = "SUPER", action = act.ActivateCommandPalette },
	{ key = "d", mods = "SUPER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "D", mods = "SUPER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "w", mods = "SUPER|SHIFT", action = act.CloseCurrentPane({ confirm = false }) },
	{ key = "z", mods = "SUPER", action = act.TogglePaneZoomState },
	{ key = "Enter", mods = "SUPER", action = act.ToggleFullScreen },
	{ key = "phys:Space", mods = "SUPER", action = act.QuickSelect },
	{ key = "c", mods = "SUPER|SHIFT", action = act.ActivateCopyMode },
	{ key = "[", mods = "SUPER", action = act.ActivateTabRelative(-1) },
	{ key = "]", mods = "SUPER", action = act.ActivateTabRelative(1) },
	{ key = "h", mods = "SUPER|ALT", action = act.ActivatePaneDirection("Left") },
	{ key = "j", mods = "SUPER|ALT", action = act.ActivatePaneDirection("Down") },
	{ key = "k", mods = "SUPER|ALT", action = act.ActivatePaneDirection("Up") },
	{ key = "l", mods = "SUPER|ALT", action = act.ActivatePaneDirection("Right") },
	{ key = "h", mods = "SUPER|SHIFT", action = act.AdjustPaneSize({ "Left", 3 }) },
	{ key = "j", mods = "SUPER|SHIFT", action = act.AdjustPaneSize({ "Down", 2 }) },
	{ key = "k", mods = "SUPER|SHIFT", action = act.AdjustPaneSize({ "Up", 2 }) },
	{ key = "l", mods = "SUPER|SHIFT", action = act.AdjustPaneSize({ "Right", 3 }) },
}

return config
