sketchybar --add item front_app left \
	--set front_app script="$PLUGIN_DIR/front_app.sh" \
	label.font="Iosevka Comfy:Regular:14.0" \
	label.max_chars=20 \
	background.color=$COLOR_BL \
	background.corner_radius=8 \
	background.height=22 \
	background.drawing=on \
	--subscribe front_app front_app_switched
