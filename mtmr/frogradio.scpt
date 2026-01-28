tell application "System Events"
	try
		if not (exists process "FrogRadio") then
			return ""
		end if
	on error
		return ""
	end try
	
	tell process "FrogRadio"
		try
			-- Extract full station text (includes description and station name)
			set fullStationText to value of static text 1 of window 1
			
			-- Extract song info (Artist - Song)
			set artistAndSong to value of static text 4 of window 1
			
			-- Check if the station is "stopped" or "paused"
			if artistAndSong contains "stopped" or artistAndSong contains "paused" then
				return "" -- Hide the text if the song is stopped or paused
			end if
			
			-- Extract station name (strip out the description before the "|")
			if fullStationText contains "|" then
				set AppleScript's text item delimiters to "|"
				set stationName to text item -1 of fullStationText
				set AppleScript's text item delimiters to "" -- Reset delimiters
			else
				set stationName to fullStationText -- Fallback if no "|"
			end if
			
			-- Clean up station name if it includes a description part
			set stationName to my cleanStationName(stationName)
			
			return "🎵 " & artistAndSong & " on " & stationName
		on error
			return ""
		end try
	end tell
end tell

-- Helper function to clean up station name and remove unnecessary text
on cleanStationName(station)
	-- Check if there's any description text after the station name and remove it
	if station contains "(" then
		set AppleScript's text item delimiters to "("
		set station to text item 1 of station
		set AppleScript's text item delimiters to "" -- Reset delimiters
	end if
	return station
end cleanStationName
