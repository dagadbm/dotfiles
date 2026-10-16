#!/usr/bin/env bash
set -x

# reference
# http://mths.be/macos
# https://github.com/kevinSuttle/macOS-Defaults/blob/master/REFERENCE.md
# https://github.com/pawelgrzybek/dotfiles/blob/master/setup-macos.sh

# Close any open System Settings panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Settings" to quit'

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.macos` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

###############################################################################
# General UI/UX                                                               #
###############################################################################

# Use dark mode
defaults write NSGlobalDomain AppleInterfaceStyle -string "Dark"

# Remove the Liquid Glass tint from windows and controls
defaults write NSGlobalDomain NSGlassTintAmount -int 0

# Use a blurred (translucent) menu bar
defaults write NSGlobalDomain SLSMenuBarUseBlurredAppearance -bool true

# Always show scrollbars
defaults write NSGlobalDomain AppleShowScrollBars -string "Always"

# Don’t minimize windows when double-clicking their title bar
defaults write NSGlobalDomain AppleMiniaturizeOnDoubleClick -bool false

# Save to disk (not to iCloud) by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Disable the “Are you sure you want to open this application?” dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Disable automatic capitalization as it’s annoying when typing code
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

# Disable smart dashes as they’re annoying when typing code
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Disable automatic period substitution as it’s annoying when typing code
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

# Disable smart quotes as they’re annoying when typing code
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

# Disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# Disable auto-correct in Safari and other WebKit text fields
defaults write NSGlobalDomain WebAutomaticSpellingCorrectionEnabled -bool false

# Disable inline predictive text
defaults write NSGlobalDomain NSAutomaticInlinePredictionEnabled -bool false

# Disable text completion suggestions
defaults write NSGlobalDomain NSAutomaticTextCompletionEnabled -bool false

# Keep Reduce motion off: on, Space swipes lose the slide and look jagged
defaults write com.apple.universalaccess reduceMotion -bool false

# Disable Siri
defaults write com.apple.assistant.support "Assistant Enabled" -bool false

# Hide Siri from the menu bar
defaults write com.apple.Siri StatusMenuVisible -bool false

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Expand print panel by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# Automatically quit printer app once the print jobs complete
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

# Set sidebar icon size to small
defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 1

# Increase window resize speed for Cocoa applications
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001

# Disable animations when opening and closing windows
defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false

# Disable Photos/Image Capture opening automatically when devices are plugged in
defaults write com.apple.ImageCapture disableHotPlug -bool true


###############################################################################
# Window Manager (Stage Manager, tiling, desktop)                             #
###############################################################################

# Only show the desktop on wallpaper click when Stage Manager is on
defaults write com.apple.WindowManager EnableStandardClickToShowDesktop -bool false

# Remove the gaps between tiled windows
defaults write com.apple.WindowManager EnableTiledWindowMargins -bool false

# Disable Stage Manager
defaults write com.apple.WindowManager GloballyEnabled -bool false

# Stage Manager: show windows from an application all at once
defaults write com.apple.WindowManager AppWindowGroupingBehavior -int 1

# Stage Manager: hide the recent apps strip
defaults write com.apple.WindowManager AutoHide -bool true

# Stage Manager: hide desktop items
defaults write com.apple.WindowManager HideDesktop -bool true

# Hide widgets in Stage Manager, show them on the regular desktop
defaults write com.apple.WindowManager StageManagerHideWidgets -bool true
defaults write com.apple.WindowManager StandardHideWidgets -bool false


###############################################################################
# Menu bar                                                                    #
###############################################################################

# Use a 24-hour clock everywhere
defaults write NSGlobalDomain AppleICUForce24HourTime -bool true

# Clock: show day of week, hide AM/PM (24-hour clock)
defaults write com.apple.menuextra.clock ShowDayOfWeek -bool true
defaults write com.apple.menuextra.clock ShowAMPM -bool false
defaults write com.apple.menuextra.clock ShowDate -int 0


###############################################################################
# Trackpad, mouse, keyboard, Bluetooth accessories, and input                 #
###############################################################################

# Trackpad (built-in): one-finger light tap is a left click, for this user and the login screen
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
# Login screen reads the per-Mac (-currentHost) value
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Trackpad (built-in): two-finger click or tap is a right click, no corner right-click
defaults write com.apple.AppleMultitouchTrackpad TrackpadRightClick -bool true
# Corner right-click values: 0 = off, 1 = bottom left, 2 = bottom right
defaults write com.apple.AppleMultitouchTrackpad TrackpadCornerSecondaryClick -int 0
# System Settings stores the right-click options per Mac (-currentHost)
defaults -currentHost write NSGlobalDomain com.apple.trackpad.enableSecondaryClick -bool true
defaults -currentHost write NSGlobalDomain com.apple.trackpad.trackpadCornerClickBehavior -int 0

# Enable “natural” (Lion-style) scrolling
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool true

# Enable full keyboard access for all controls
# (e.g. enable Tab in modal dialogs)
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# Disable press-and-hold for keys in favor of key repeat
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Set a blazingly fast keyboard repeat rate
# KeyRepeat: normal minimum is 2 (30 ms)
defaults write NSGlobalDomain KeyRepeat -int 3
# InitialKeyRepeat: normal minimum is 15 (225 ms)
defaults write NSGlobalDomain InitialKeyRepeat -int 20

# Press the globe (fn) key to change the input source (keyboard language)
# Possible values: 0 = do nothing, 1 = change input source, 2 = show emoji, 3 = start dictation
defaults write com.apple.HIToolbox AppleFnUsageType -int 1

# Disable the Spotlight ⌘ + Space shortcut (Alfred uses it instead)
# 64 = Show Spotlight search; parameters 32, 49, 1048576 = Space, keycode 49, ⌘
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 64 "<dict><key>enabled</key><false/><key>value</key><dict><key>parameters</key><array><integer>32</integer><integer>49</integer><integer>1048576</integer></array><key>type</key><string>standard</string></dict></dict>"


###############################################################################
# Energy saving                                                               #
###############################################################################

# Enable lid wakeup on battery and charger
sudo pmset -a lidwake 1

# Never put the system to sleep while on charger (closing the lid still sleeps)
sudo pmset -c sleep 0

# Put the system to sleep after 15 minutes idle on battery
sudo pmset -b sleep 15

# Never spin down disks while on charger
sudo pmset -c disksleep 0

# Spin down disks after 15 minutes idle on battery
sudo pmset -b disksleep 15

# Enable Power Nap on charger (mail, iCloud, Time Machine while asleep)
sudo pmset -c powernap 1

# Disable Power Nap on battery to save power
sudo pmset -b powernap 0

# Turn off the display after 10 minutes on charger
sudo pmset -c displaysleep 10

# Turn off the display after 10 minutes on battery
sudo pmset -b displaysleep 10

# Disable the charging sound and kill the PowerChime app that plays it
defaults write com.apple.PowerChime ChimeOnNoHardware -bool true

###############################################################################
# Sound                                                                       #
###############################################################################

# Disable user interface sound effects (Trash, screenshots, AirDrop)
defaults write NSGlobalDomain com.apple.sound.uiaudio.enabled -int 0

# Disable the click sound when changing the volume
defaults write NSGlobalDomain com.apple.sound.beep.feedback -int 0

# Disable the startup chime
sudo nvram StartupMute=%01

###############################################################################
# Spotlight                                                                   #
# Spotlight indexing stays on: Alfred searches files through it               #
###############################################################################

# Disable the Finder search window ⌥ + ⌘ + Space shortcut
# 65 = Show Finder search window; parameters 32, 49, 1572864 = Space, keycode 49, ⌥ + ⌘
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 65 "<dict><key>enabled</key><false/><key>value</key><dict><key>parameters</key><array><integer>32</integer><integer>49</integer><integer>1572864</integer></array><key>type</key><string>standard</string></dict></dict>"

# Hide the Spotlight icon from the menu bar
defaults write com.apple.Spotlight "NSStatusItem VisibleCC Item-0" -bool false

# Disable Siri Suggestions in Look Up and Spotlight
defaults write com.apple.lookup.shared LookupSuggestionsDisabled -bool true

###############################################################################
# Firewall                                                                    #
###############################################################################

# Turn the application firewall on (blocks incoming connections to apps,
# e.g. dev servers bound to 0.0.0.0, on untrusted networks)
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on

# Let built-in Apple software receive incoming connections through the firewall
# (keeps AirDrop and other system sharing services working)
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setallowsigned on

# Turn stealth mode on (the Mac ignores pings and port probes)
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setstealthmode on

###############################################################################
# Tailscale                                                                   #
###############################################################################

# Disable Remote Login (sshd): remote shells go through Tailscale SSH instead,
# which listens only on the tailnet, so nothing answers SSH on the LAN
# (needs Full Disk Access for the terminal running this script)
sudo systemsetup -f -setremotelogin off

###############################################################################
# Screen                                                                      #
###############################################################################

# Require password immediately after sleep or screen saver begins
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Create the screenshots folder (macOS falls back to the Desktop if it is missing)
mkdir -p "${HOME}/Documents/Screenshots"

# Save screenshots and screen recordings to ~/Documents/Screenshots
# `location` is the legacy key; newer macOS reads the two keys below
defaults write com.apple.screencapture location -string "${HOME}/Documents/Screenshots"
defaults write com.apple.screencapture location-screenshot -string "${HOME}/Documents/Screenshots"
defaults write com.apple.screencapture location-screenrecording -string "${HOME}/Documents/Screenshots"

# Copy a picture of a selected area to the clipboard with ⌘ + § (replaces ⌘ + ⌃ + ⇧ + 4)
# 31 = Copy picture of selected area to the clipboard; parameters 65535, 10, 1048576 = no character, keycode 10 (§), ⌘
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 31 "<dict><key>enabled</key><true/><key>value</key><dict><key>parameters</key><array><integer>65535</integer><integer>10</integer><integer>1048576</integer></array><key>type</key><string>standard</string></dict></dict>"

# Open the screenshot and recording toolbar with ⌘ + ⇧ + § (replaces ⌘ + ⇧ + 5)
# 184 = Screenshot and recording options; parameters 65535, 10, 1179648 = no character, keycode 10 (§), ⌘ + ⇧
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 184 "<dict><key>enabled</key><true/><key>value</key><dict><key>parameters</key><array><integer>65535</integer><integer>10</integer><integer>1179648</integer></array><key>type</key><string>standard</string></dict></dict>"

# Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
defaults write com.apple.screencapture type -string "png"

# Show the mouse pointer in screenshots
defaults write com.apple.screencapture showsCursor -bool true

# Default screenshot mode: capture a window
# Possible values: `window`, `selection`, `screen`
defaults write com.apple.screencapture style -string "window"

# Disable the shadow around window screenshots
defaults write com.apple.screencapture disable-shadow -bool true

###############################################################################
# Finder                                                                      #
###############################################################################

# Finder: allow quitting via ⌘ + Q; doing so will also hide desktop icons
defaults write com.apple.finder QuitMenuItem -bool true

# Finder: disable window animations and Get Info animations
defaults write com.apple.finder DisableAllAnimations -bool true

# Set Home as the default location for new Finder windows
# For other paths, use `PfLo` and `file:///full/path/here/`
defaults write com.apple.finder NewWindowTarget -string "PfHm"
# Path used when NewWindowTarget is `PfLo`
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"

# Show icons for hard drives, servers, and removable media on the desktop
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

# Finder: show hidden files by default
defaults write com.apple.finder AppleShowAllFiles -bool true

# Finder: show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Finder: show sidebar
defaults write com.apple.finder ShowSidebar -bool true

# Finder: show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Finder: show path bar
defaults write com.apple.finder ShowPathbar -bool true

# Display full POSIX path as Finder window title
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true
defaults write com.apple.finder _FXSortFoldersFirstOnDesktop -bool true

# Group and arrange items by name
defaults write com.apple.finder FXPreferredGroupBy -string "Name"
defaults write com.apple.finder FXArrangeGroupViewBy -string "Name"

# When performing a search, search the entire Mac by default
# Possible values: `SCev` = This Mac, `SCcf` = current folder, `SCsp` = previous scope
defaults write com.apple.finder FXDefaultSearchScope -string "SCev"

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Disable the warning before emptying the Trash
defaults write com.apple.finder WarnOnEmptyTrash -bool false

# Remove items from the Trash after 30 days
defaults write com.apple.finder FXRemoveOldTrashItems -bool true


# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true


# Automatically open a new Finder window when a volume is mounted
defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true


# Use list view in all Finder windows by default
# Four-letter codes for the other view modes: `icnv`, `clmv`, `glyv`
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"


# Show the ~/Library folder
chflags nohidden ~/Library

# Show the /Volumes folder
sudo chflags nohidden /Volumes


###############################################################################
# Dock, Mission Control, and hot corners                                      #
###############################################################################

# Enable highlight hover effect for the grid view of a stack (Dock)
defaults write com.apple.dock mouse-over-hilite-stack -bool true

# Set the icon size of Dock items to 36 pixels
defaults write com.apple.dock tilesize -int 36

# Change minimize/maximize window effect
defaults write com.apple.dock mineffect -string "scale"

# Minimize windows into their application’s icon
defaults write com.apple.dock minimize-to-application -bool true

# Enable spring loading for all Dock items
defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool true

# Scroll up on a Dock icon to show all of the app’s windows
defaults write com.apple.dock scroll-to-open -bool true

# Show indicator lights for open applications in the Dock
defaults write com.apple.dock show-process-indicators -bool true

# Wipe all (default) app icons from the Dock
# This is only really useful when setting up a new Mac, or if you don’t use
# the Dock to launch apps.
defaults write com.apple.dock persistent-apps -array

# Show only open applications in the Dock
defaults write com.apple.dock static-only -bool true

# Don’t animate opening applications from the Dock
defaults write com.apple.dock launchanim -bool false

# Don’t group windows by application in Mission Control
# (i.e. use the old Exposé behavior instead)
defaults write com.apple.dock expose-group-by-app -bool false

# Don’t automatically rearrange Spaces based on most recent use
defaults write com.apple.dock mru-spaces -bool false

# Remove the auto-hiding Dock delay
defaults write com.apple.dock autohide-delay -float 0
# Remove the animation when hiding/showing the Dock
defaults write com.apple.dock autohide-time-modifier -float 0

# Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true

# Make Dock icons of hidden applications translucent
defaults write com.apple.dock showhidden -bool true

# Don’t show recent applications in Dock
defaults write com.apple.dock show-recents -bool false

# Place the Dock at the bottom of the screen
# Possible values: `bottom`, `left`, `right`
defaults write com.apple.dock orientation -string "bottom"

# Disable Dock icon magnification on hover
defaults write com.apple.dock magnification -bool false

# Hot corners (each `-modifier 0` means no modifier key is needed)
# Possible values:
#  1: disabled (what System Settings writes for “-”)
#  2: Mission Control
#  3: Show application windows
#  4: Desktop
#  5: Start screen saver
#  6: Disable screen saver
# 10: Put display to sleep
# 11: Apps
# 12: Notification Center
# 13: Lock Screen
# 14: Quick Note

# Top left screen corner → disabled
defaults write com.apple.dock wvous-tl-corner -int 1
defaults write com.apple.dock wvous-tl-modifier -int 0
# Bottom left screen corner → Apps
defaults write com.apple.dock wvous-bl-corner -int 11
defaults write com.apple.dock wvous-bl-modifier -int 0
# Top right screen corner → Notification Center
defaults write com.apple.dock wvous-tr-corner -int 12
defaults write com.apple.dock wvous-tr-modifier -int 0
# Bottom right screen corner → disabled
defaults write com.apple.dock wvous-br-corner -int 1
defaults write com.apple.dock wvous-br-modifier -int 0

###############################################################################
# Safari & WebKit                                                             #
###############################################################################

# Privacy: don’t send search queries to Apple
defaults write com.apple.Safari UniversalSearchEnabled -bool false
defaults write com.apple.Safari SuppressSearchSuggestions -bool true

# Enable the Develop menu and the Web Inspector in Safari
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true

###############################################################################
# Time Machine                                                                #
###############################################################################

# Prevent Time Machine from prompting to use new hard drives as backup volume
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

###############################################################################
# Activity Monitor                                                            #
###############################################################################

# Show the main window when launching Activity Monitor
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

# Visualize CPU usage in the Activity Monitor Dock icon
defaults write com.apple.ActivityMonitor IconType -int 5

# Show all processes in Activity Monitor
defaults write com.apple.ActivityMonitor ShowCategory -int 0

# Sort Activity Monitor results by CPU usage
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
# SortDirection: 0 = descending
defaults write com.apple.ActivityMonitor SortDirection -int 0

###############################################################################
# TextEdit and Disk Utility                                                   #
###############################################################################

# Use plain text mode for new TextEdit documents
defaults write com.apple.TextEdit RichText -int 0
# Open and save files as UTF-8 in TextEdit
# Encoding 4 = UTF-8
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

# Enable the debug menu in Disk Utility
defaults write com.apple.DiskUtility DUDebugMenuEnabled -bool true
defaults write com.apple.DiskUtility advanced-image-options -bool true

###############################################################################
# Software Update and App Store                                               #
###############################################################################

# Enable the automatic update check
defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true

# Check for software updates daily, not just once per week
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

# Download newly available updates in background
defaults write com.apple.SoftwareUpdate AutomaticDownload -int 1

# Install System data files & security updates
defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 1

# Turn on app auto-update
defaults write com.apple.commerce AutoUpdate -bool true

###############################################################################
# Kill affected applications                                                  #
###############################################################################

# Restart the apps that cache these settings so changes apply without a logout
killall Dock Finder SystemUIServer cfprefsd PowerChime 2>/dev/null || true
