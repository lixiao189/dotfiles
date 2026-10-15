local wezterm = require("wezterm")

local config = wezterm.config_builder()
local act = wezterm.action

-- WezTerm re-evaluates this file whenever the system appearance changes, so
-- reading it once here is enough to follow light/dark switches live.
local dark = not wezterm.gui or wezterm.gui.get_appearance():find("Dark") ~= nil

-- Catppuccin Latte / Mocha base tones. The tab bar doubles as the titlebar, so
-- everything in it sits on `base` to blend into the terminal background.
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

-- Frosted glass. Dark mode can go more see-through since light text on a
-- blurred backdrop stays legible; light mode needs more body to keep contrast.
local OPACITY = dark and 0.82 or 0.88
local BLUR = 40

-- `#rrggbb` -> `rgba(r,g,b,a)`. Chrome (tab bar, titlebar) is painted with
-- explicit colors that ignore window_background_opacity, so it needs its own
-- alpha to frost along with the terminal instead of sitting on top as a slab.
local function glass(hex, alpha)
	local r, g, b = hex:match("#(%x%x)(%x%x)(%x%x)")
	return string.format("rgba(%d,%d,%d,%s)", tonumber(r, 16), tonumber(g, 16), tonumber(b, 16), alpha or OPACITY)
end

-- Rendering. WebGpu uses Metal on macOS and is the faster path on Apple GPUs.
-- Nothing animates, so animation_fps stays at its minimum.
config.front_end = "WebGpu"
config.max_fps = 120
config.animation_fps = 1
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
config.command_palette_bg_color = p.mantle
config.command_palette_fg_color = p.text
config.command_palette_font_size = 15
config.char_select_bg_color = p.mantle
config.char_select_fg_color = p.text
config.colors = {
	split = p.surface1,
	compose_cursor = p.peach,
	tab_bar = {
		background = glass(p.base),
		inactive_tab_edge = glass(p.base, 0),
		active_tab = { bg_color = glass(p.surface0, 0.9), fg_color = p.text, intensity = "Bold" },
		inactive_tab = { bg_color = glass(p.base, 0), fg_color = p.overlay },
		inactive_tab_hover = { bg_color = glass(p.surface0, 0.5), fg_color = p.subtext },
	},
}
config.inactive_pane_hsb = { saturation = 0.9, brightness = dark and 0.75 or 0.95 }
config.default_cursor_style = "SteadyBlock"
-- Never blink, even when an app asks for it.
config.cursor_blink_rate = 0
-- Bar/underline cursors (e.g. from vim insert mode) default to ~1px; thicken them.
config.cursor_thickness = "1pt"

-- Window. The titlebar is drawn by WezTerm (integrated buttons) so it can
-- share the same frosted tint as the terminal instead of the native material.
config.initial_rows = 28
config.initial_cols = 90
config.window_padding = { left = 12, right = 12, top = 8, bottom = 4 }
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE|MACOS_FORCE_ENABLE_SHADOW"
config.integrated_title_button_style = "MacOsNative"
config.integrated_title_buttons = { "Close", "Hide", "Maximize" }
config.window_frame = {
	font = wezterm.font({ family = "Maple Mono NF CN", weight = "Medium" }),
	font_size = 12,
	active_titlebar_bg = glass(p.base),
	inactive_titlebar_bg = glass(p.mantle),
	border_left_width = 0,
	border_right_width = 0,
	border_top_height = 0,
	border_bottom_height = 0,
}
config.window_background_opacity = OPACITY
config.macos_window_background_blur = BLUR
-- Cell backgrounds painted by apps (Neovim's Normal bg, prompts) stay at the
-- window opacity so the glass reads through full-screen TUIs too.
config.text_background_opacity = 1.0
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

-- Center "<index> <title>" in at least TAB_MIN_WIDTH cells so short titles
-- don't make stubby tabs. The index takes the accent color on the active tab;
-- a zoomed pane gets a magnifier so it's obvious other panes are hidden.
local TAB_MIN_WIDTH = 18
local nf = wezterm.nerdfonts
wezterm.on("format-tab-title", function(tab, _, _, _, _, max_width)
	local title = tab.tab_title ~= "" and tab.tab_title or tab.active_pane.title
	local index = tostring(tab.tab_index + 1)
	local zoom = tab.active_pane.is_zoomed and (" " .. nf.md_magnify) or ""
	local reserved = wezterm.column_width(index) + wezterm.column_width(zoom) + 3
	title = wezterm.truncate_right(title, max_width - reserved)
	local body_width = wezterm.column_width(index) + 1 + wezterm.column_width(title) + wezterm.column_width(zoom)
	local width = math.min(math.max(TAB_MIN_WIDTH, body_width + 2), max_width)
	local left = math.floor((width - body_width) / 2)
	return {
		{ Text = string.rep(" ", left) },
		{ Foreground = { Color = tab.is_active and p.accent or p.overlay } },
		{ Text = index .. " " },
		"ResetAttributes",
		{ Text = title .. zoom .. string.rep(" ", width - body_width - left) },
	}
end)

-- The native traffic lights overlap the first tab; a left status pushes tabs clear of them.
local LEFT_STATUS = wezterm.format({ { Text = "  " } })

-- Setting a status repaints the tab bar on the GUI thread, which competes with
-- keystroke rendering. Only push it when the text actually changed.
local last_status = {}
wezterm.on("update-status", function(window, pane)
	local cwd = pane:get_current_working_dir()
	local path = cwd and cwd.file_path or ""
	local name = path:match("([^/]+)/?$") or path
	local workspace = window:active_workspace()
	local prefix = workspace ~= "default" and (nf.cod_layers .. " " .. workspace .. "   ") or ""
	local right = prefix .. nf.md_folder_outline .. " " .. name .. "  "

	local id = window:window_id()
	if last_status[id] == right then
		return
	end
	last_status[id] = right
	window:set_left_status(LEFT_STATUS)
	window:set_right_status(wezterm.format({
		{ Foreground = { Color = p.subtext } },
		{ Text = right },
	}))
end)

return config
