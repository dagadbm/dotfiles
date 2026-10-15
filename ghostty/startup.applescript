#!/usr/bin/osascript

tell application "Ghostty"
  -- the bootstrap window may not exist yet at cold launch
  repeat 100 times
    try
      set bootWindow to front window
      exit repeat
    end try
    delay 0.1
  end repeat

  set tmuxConfig to new surface configuration
  set initial input of tmuxConfig to "tmux-restore" & linefeed
  set startupWindow to new window with configuration tmuxConfig
  perform action "set_tab_title:tmux" on focused terminal of selected tab of startupWindow

  set herdrConfig to new surface configuration
  set initial input of herdrConfig to "herdr" & linefeed
  set herdrTab to new tab in startupWindow with configuration herdrConfig
  perform action "set_tab_title:herdr" on focused terminal of herdrTab

  activate window startupWindow
  close window bootWindow
end tell
