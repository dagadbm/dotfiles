local wezterm = require 'wezterm'
local mux = wezterm.mux
local act = wezterm.action

wezterm.on('gui-startup', function(cmd)
  local tmux_tab, tmux_pane, window = mux.spawn_window(cmd or {})
  tmux_tab:set_title 'tmux'
  local herdr_tab, herdr_pane = window:spawn_tab {}
  herdr_tab:set_title 'herdr'
  tmux_tab:activate()
  window:gui_window():toggle_fullscreen()

  tmux_pane:send_text 'tmux-restore\n'
  herdr_pane:send_text 'herdr\n'
end)

wezterm.on('format-window-title', function(tab)
  return tab.tab_title ~= '' and tab.tab_title or 'wezterm'
end)

return {
  -- https://wezfurlong.org/wezterm/config/mouse.html
  font = wezterm.font 'JetBrainsMono Nerd Font Mono',
  font_size = 12,
  line_height = 1.2,
  color_scheme = 'astrodark',
  enable_tab_bar = true,
  hide_tab_bar_if_only_one_tab = true,
  max_fps = 60,
  native_macos_fullscreen_mode = true,
  enable_kitty_keyboard = false,
  enable_scroll_bar = false,
  exit_behavior = 'CloseOnCleanExit',
  window_close_confirmation = 'NeverPrompt',
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
      format = '$0',
    },
    {
      regex = [[\b[\w.+-]+@[\w-]+(\.[\w-]+)+\b(?!:)]],
      format = 'mailto:$0',
    },
  },
  -- (https://wezterm.org/config/mouse.html)
  mouse_bindings = {
    -- Change the default click behavior so that it only selects
    -- text and doesn't open hyperlinks
    {
      event = { Up = { streak = 1, button = 'Left' } },
      mods = 'NONE',
      action = act.CompleteSelection 'ClipboardAndPrimarySelection',
    },
    -- and make CMD-Click open hyperlinks
    {
      event = { Up = { streak = 1, button = 'Left' } },
      mods = 'CMD',
      mouse_reporting = true,
      action = act.OpenLinkAtMouseCursor,
    },
    -- https://wezterm.org/config/mouse.html#gotcha-on-binding-an-up-event-only
    {
      event = { Down = { streak = 1, button = 'Left' } },
      mods = 'NONE',
      action = act.Nop,
    },
    {
      event = { Down = { streak = 1, button = 'Left' } },
      mods = 'CMD',
      mouse_reporting = true,
      action = act.Nop,
    },
  },
  keys = {
    {
      key = 'w',
      mods = 'CMD',
      action = act.CloseCurrentTab { confirm = false },
    },
    -- paste from the clipboard
    { key = 'V',
      mods = 'CMD',
      action = act.PasteFrom 'Clipboard',
    },
  },
  term = 'xterm-256color'
}
