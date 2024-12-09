#!/bin/bash

# Set Icon path to Parameter 4 for deployment via Jamf
icon="$4"

# Path to Jamf Helper
JAMF_HELPER="/Library/Application Support/Jamf/bin/jamfHelper.app/Contents/MacOS/jamfHelper"

# Calculate disk usage, filter for directories larger than 1GB, and sort
output=$(sudo du -h /System/Volumes/Data 2>/dev/null | grep -E "^[0-9]" | grep "G\t" | sort | awk '{printf "%-10s %s\n", $1, $2}')

# Check if the output is empty
if [[ -z "$output" ]]; then
    output="No directories larger than 1GB found."
else
    # Get the last 20 lines of the sorted output
    output=$(echo "$output" | tail -n 20)
fi

# Display the output using Jamf Helper with a timeout of 60 seconds
"$JAMF_HELPER" -windowType utility \
-title "Disk Usage Report" \
-description "$output" \
-button1 "OK" \
-icon "$icon" \
-timeout 60
