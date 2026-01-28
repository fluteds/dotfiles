#!/bin/sh

source "$HOME/.config/icons.sh"

# Hide the extra icons if the app is running subprocesses. TODO: Make a better way to handle this because this is not very efficient.
if [ -z "$2" ]; then
	exit 0  # just exit silently
fi

case "$1" in

	# --- Terminal & CLI ---
	"Terminal" | "Warp" | "iTerm2")
		RESULT=$ICON_TERM
		if grep -q "btop" <<< $2; then
			RESULT=$ICON_CHART
		fi
		if grep -q "brew" <<< $2; then
			RESULT=$ICON_PACKAGE
		fi
		if grep -q "nvim" <<< $2; then
			RESULT=$ICON_DEV
		fi
		if grep -q "ranger" <<< $2; then
			RESULT=$ICON_FILE
		fi
		if grep -q "lazygit" <<< $2; then
			RESULT=$ICON_GIT
		fi
		if grep -q "taskwarrior-tui|todo.sh" <<< $2; then
			RESULT=$ICON_LIST
		fi
		if grep -q "unimatrix\|pipes.sh" <<< $2; then
			RESULT=$ICON_SCREENSAVER
		fi
		if grep -q "terminal-rain" <<< $2; then
			RESULT=$ICON_SCREENSAVER
		fi
		if grep -q "bat" <<< $2; then
			RESULT=$ICON_NOTE
		fi
		if grep -q "tty-clock" <<< $2; then
			RESULT=$ICON_CLOCK
		fi
		;;

	# --- System & Utilities ---
	"System Settings" | "System Information" | "TinkerTool")
		RESULT=$ICON_COG
		;;
	"Activity Monitor")
		RESULT=$ICON_CHART
		;;
	"Disk Utility")
		RESULT=$ICON_DISK
		;;
	"Screenshot" | "Preview")
		RESULT=$ICON_PREVIEW
		;;
	"Passwords")
		RESULT=$ICON_PASSKEY
		;;

	# --- Networking & VPN ---
	"oblivion-desktop" | "Mullvad VPN" | "NordVPN")
		RESULT=$ICON_VPN
		;;
	"Microsoft Remote Desktop" | "VNC Viewer" | "Parsec")
		RESULT=$ICON_REMOTEDESKTOP
		;;

	# --- Browsers & Web ---
	"Safari")
		RESULT=$ICON_SAFARI
		;;
	"Firefox" | "Firefox Nightly")
		RESULT=$ICON_FIREFOX
		;;
	"Zen Browser")
		RESULT=$ICON_WEB
		;;
	"Google Chrome" | "Ungoogled Chromium")
	  RESULT=$ICON_CHROME
  		;;

	# --- Communication ---
	"Mail" | "Microsoft Outlook")
		RESULT=$ICON_MAIL
		;;
	"Messages" | "Telegram" | "Halloy")
		RESULT=$ICON_CHAT
		;;
	"Discord" | "Vencord")
		RESULT=$ICON_DISCORD
		;;
	"FaceTime" | "zoom.us")
		RESULT=$ICON_VIDEOCHAT
		;;

	# --- Productivity ---
	"Calendar")
		RESULT=$ICON_CALENDAR
		;;
	"Reminders" | "sleek")
		RESULT=$ICON_LIST
		;;
	"Notes" | "TextEdit" | "Stickies" | "Microsoft Word" | "Zettlr" | "Obsidian")
		RESULT=$ICON_NOTE
		;;
	"Calculator" | "Numi")
		RESULT=$ICON_CALC
		;;
	"Font Book" | "Dictionary")
		RESULT=$ICON_BOOKINFO
		;;

	# --- Development ---
	"Xcode")
		RESULT=$ICON_DEV
		;;
	"Code")
		RESULT=$ICON_VSCODE
		;;
	"OrcaSlicer" | "Bambu Studio")
	  RESULT=$ICON_3D
  		;;

	# --- Files & Finder ---
	"Finder")
		RESULT=$ICON_FILE
		;;

	# --- Media ---
	"Music" | "Spotify" | "Elmedia Player")
		RESULT=$ICON_MUSIC
		;;
	"TV" | "QuickTime Player" | "mpv")
		RESULT=$ICON_PLAY
		;;
	"VLC")
		RESULT=$ICON_VLC
		;;
	"Photos")
		RESULT=$ICON_PHOTOS
		;;
	"Adobe Photoshop 2025")
		RESULT=$ICON_PHOTOSHOP
		;;
	"Photo Booth")
		RESULT=$ICON_CAMERA
		;;
	"LocalSend" | "Podcasts")
		RESULT=$ICON_PODCAST
		;;
	"Voice Memos")
		RESULT=$ICON_MICROPHONE
		;;

	# --- Downloads ---
	"Folx" | "Free Download Manager" | "JDownloader 2")
		RESULT=$ICON_DOWNLOAD
		;;
	"Progressive Downloaded" | "Transmission")
		RESULT=$ICON_DOWNLOAD
		;;

	# --- Home & Automation ---
	"HOME" | "Home Assistant")
		RESULT=$ICON_HOMEAUTOMATION
		;;

	# --- Maps & Location ---
	"Maps" | "Find My")
		RESULT=$ICON_MAP
		;;

	# --- Miscellaneous ---
	"SF Symbols")
		RESULT=$ICON_ICON
		;;
	"Prism Launcher" | "Minecraft")
		RESULT=$ICON_MINECRAFT
		;;
	"iPhone Mirroring")
		RESULT=$ICON_MIRRORING
		;;

	# --- Weather & Clock ---
	"Weather" | "CARROT Weather")
		RESULT=$ICON_WEATHER
		;;
	"Clock")
		RESULT=$ICON_CLOCK
		;;

	# --- Default Fallback ---
	*)
		RESULT=$ICON_APP
		;;
esac

echo $RESULT
