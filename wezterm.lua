local wezterm = require("wezterm")

local config = wezterm.config_builder()
local act = wezterm.action

-- WezTerm re-evaluates this file whenever the system appearance changes, so
-- reading it once here is enough to follow light/dark switches live.
local dark = not wezterm.gui or wezterm.gui.get_appearance():find("Dark") ~= nil

-- Catppuccin Latte / Mocha base tones. The tab bar doubles as the titlebar, so
-- everything in it sits on `base` to blend into the terminal background.
local p = dark
		and { base = "#1e1e2e", mantle = "#181825", surface0 = "#313244", text = "#cdd6f4", subtext = "#a6adc8", overlay = "#6c7086" }
	or { base = "#eff1f5", mantle = "#e6e9ef", surface0 = "#ccd0da", text = "#4c4f69", subtext = "#6c6f85", overlay = "#9ca0b0" }

-- Rendering. WebGpu uses Metal on macOS and is the faster path on Apple GPUs.
-- animation_fps only affects cursor blinks and easing, so keep it well below max_fps.
config.front_end = "WebGpu"
config.max_fps = 120
config.animation_fps = 30
config.unicode_version = 15

-- Font. Same face Ghostty uses: Latin + CJK + Nerd Font icons in one family.
config.font_size = 14
config.line_height = 1.05
config.font = wezterm.font_with_fallback({
	{ family = "Maple Mono NF CN", weight = "Regular" },
	{ family = "PingFang SC", weight = "Regular" },
	"Apple Color Emoji",
})
config.bold_brightens_ansi_colors = "BrightAndBold"
config.anti_alias_custom_block_glyphs = true

-- Colors. Same pairing as Ghostty: Latte in light mode, Mocha in dark mode.
config.color_scheme = dark and "Catppuccin Mocha" or "Catppuccin Latte"
config.command_palette_bg_color = p.base
config.command_palette_fg_color = p.text
config.colors = {
	tab_bar = {
		background = p.base,
		inactive_tab_edge = p.base,
		active_tab = { bg_color = p.surface0, fg_color = p.text },
		inactive_tab = { bg_color = p.base, fg_color = p.overlay },
		inactive_tab_hover = { bg_color = p.mantle, fg_color = p.subtext },
	},
}
config.inactive_pane_hsb = { saturation = 0.9, brightness = dark and 0.8 or 0.95 }
config.default_cursor_style = "SteadyBlock"
config.force_reverse_video_cursor = true
-- Bar/underline cursors (e.g. from vim insert mode) default to ~1px; thicken them.
config.cursor_thickness = "1pt"

-- Window. macOS paints the native titlebar with a translucent material and
-- there is no config to make that solid (wezterm/wezterm#4433). Drawing our own
-- titlebar is the only way to get a flat, opaque bar.
config.initial_rows = 28
config.initial_cols = 90
config.window_padding = { left = 8, right = 8, top = 4, bottom = 2 }
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE|MACOS_FORCE_ENABLE_SHADOW"
config.integrated_title_button_style = "MacOsNative"
config.integrated_title_buttons = { "Close", "Hide", "Maximize" }
config.window_frame = {
	font = wezterm.font({ family = "Maple Mono NF CN", weight = "Medium" }),
	font_size = 12,
	active_titlebar_bg = p.base,
	inactive_titlebar_bg = p.mantle,
}
config.window_background_opacity = 1.0
config.macos_window_background_blur = 0
config.native_macos_fullscreen_mode = true
config.adjust_window_size_when_changing_font_size = false

-- Tab bar. INTEGRATED_BUTTONS live in it, so hiding it with one tab leaves the
-- traffic lights floating over the first terminal row.
config.use_fancy_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false
config.show_new_tab_button_in_tab_bar = false
-- The status only shows workspace and cwd; refreshing it faster buys nothing.
config.status_update_interval = 2000

-- Behavior
config.quit_when_all_windows_are_closed = true
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

-- Keys use SUPER so Neovim/shell bindings stay intact. Unset keys keep WezTerm defaults.
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

-- Center each title in at least TAB_MIN_WIDTH cells so short titles don't make stubby tabs.
local TAB_MIN_WIDTH = 16
wezterm.on("format-tab-title", function(tab, _, _, _, _, max_width)
	local title = tab.tab_title ~= "" and tab.tab_title or tab.active_pane.title
	title = wezterm.truncate_right(title, max_width - 2)
	local title_width = wezterm.column_width(title)
	local width = math.min(math.max(TAB_MIN_WIDTH, title_width + 2), max_width)
	local left = math.floor((width - title_width) / 2)
	return string.rep(" ", left) .. title .. string.rep(" ", width - title_width - left)
end)

-- The native traffic lights overlap the first tab; a left status pushes tabs clear of them.
local LEFT_STATUS = wezterm.format({ { Background = { Color = p.base } }, { Text = "  " } })

-- Setting a status repaints the tab bar on the GUI thread, which competes with
-- keystroke rendering. Only push it when the text actually changed.
local last_status = {}
wezterm.on("update-status", function(window, pane)
	local cwd = pane:get_current_working_dir()
	local path = cwd and cwd.file_path or ""
	local name = path:match("([^/]+)/?$") or path
	local workspace = window:active_workspace()
	local prefix = workspace ~= "default" and workspace .. "  " or ""
	local right = "  " .. prefix .. name .. "  "

	local id = window:window_id()
	if last_status[id] == right then
		return
	end
	last_status[id] = right
	window:set_left_status(LEFT_STATUS)
	window:set_right_status(wezterm.format({
		{ Background = { Color = p.base } },
		{ Foreground = { Color = p.overlay } },
		{ Text = right },
	}))
end)

return config
