local wezterm = require 'wezterm'
local mux = wezterm.mux

wezterm.on('gui-startup', function(cmd)
  local tab, pane, window = mux.spawn_window(cmd or {})
  -- window:gui_window():maximize()
  window:gui_window():toggle_fullscreen()
end)

return {
  font = wezterm.font 'JetBrainsMono Nerd Font Mono',
  font_size = 13,
  line_height = 1.2,
  color_scheme = 'OneDark (base16)',
  bypass_mouse_reporting_modifiers = 'CMD',
  enable_tab_bar = false,
  hide_tab_bar_if_only_one_tab = true,
  max_fps = 60,
  native_macos_fullscreen_mode = false,
  enable_kitty_keyboard = false,
  enable_scroll_bar = false,
  exit_behavior = 'CloseOnCleanExit',
  window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
  },
}
