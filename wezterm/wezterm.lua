local wezterm = require("wezterm")
local mux = wezterm.mux
local act = wezterm.action

wezterm.on("gui-startup", function(cmd)
	local tmux_tab, tmux_pane, window = mux.spawn_window(cmd or {})
	tmux_tab:set_title("WezTerm · tmux")
	local herdr_tab, herdr_pane = window:spawn_tab({})
	herdr_tab:set_title("WezTerm · herdr")
	tmux_tab:activate()
	window:gui_window():toggle_fullscreen()

	tmux_pane:send_text("tmux-restore\n")
	herdr_pane:send_text("herdr\n")
end)

wezterm.on("format-window-title", function(tab)
	return tab.tab_title ~= "" and tab.tab_title or "wezterm"
end)

return {
	-- https://wezfurlong.org/wezterm/config/mouse.html
	font = wezterm.font("JetBrainsMono Nerd Font Mono"),
	font_size = 12,
	line_height = 1.2,
	color_scheme = "astrodark",
	enable_tab_bar = true,
	hide_tab_bar_if_only_one_tab = true,
	show_new_tab_button_in_tab_bar = false,
	max_fps = 60,
	window_content_alignment = { horizontal = "Left", vertical = "Bottom" },
	native_macos_fullscreen_mode = true,
	enable_kitty_keyboard = false,
	enable_scroll_bar = false,
	exit_behavior = "CloseOnCleanExit",
	window_close_confirmation = "NeverPrompt",
	window_padding = {
		left = 0,
		right = 0,
		top = 0,
		bottom = 0,
	},
	-- https://github.com/wezterm/wezterm/issues/3803
	hyperlink_rules = {
		{
			regex = [[\b\w+://(?:[^\s()<>"'`]|\((?:[^\s()<>]|\([^\s()<>]*\))*\))*(?:[\w/#=&%~+-]|\((?:[^\s()<>]|\([^\s()<>]*\))*\))]],
			format = "$0",
		},
		{
			regex = [[\b[\w.+-]+@[\w-]+(\.[\w-]+)+\b(?!:)]],
			format = "mailto:$0",
		},
	},
	bypass_mouse_reporting_modifiers = "CMD",
	mouse_bindings = {
		{
			event = { Up = { streak = 1, button = "Left" } },
			mods = "NONE",
			action = act.CompleteSelectionOrOpenLinkAtMouseCursor("ClipboardAndPrimarySelection"),
		},
		{
			event = { Up = { streak = 1, button = "Left" } },
			mods = "CMD",
			action = act.CompleteSelectionOrOpenLinkAtMouseCursor("ClipboardAndPrimarySelection"),
		},
	},
	keys = {
		{
			key = "Escape",
			action = act.Multiple({ act.ClearSelection, act.SendKey({ key = "Escape" }) }),
		},
		{
			key = "w",
			mods = "CMD",
			action = act.CloseCurrentTab({ confirm = false }),
		},
	},
	term = "xterm-256color",
}
