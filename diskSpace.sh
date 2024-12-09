#!/bin/bash

# Path to Jamf Helper
JAMF_HELPER="/Library/Application Support/Jamf/bin/jamfHelper.app/Contents/MacOS/jamfHelper"

# Run the command to calculate disk usage, filter out errors, and sort
output=$(sudo du -h /System/Volumes/Data 2>/dev/null | grep -E "^[0-9]" | grep "G\t" | sort | awk '{printf "%-10s %s\n", $1, $2}')

# Check if the output is empty
if [[ -z "$output" ]]; then
    output="No directories larger than 1GB found."
else
    # Get the last 20 lines of the sorted output
    output=$(echo "$output" | tail -n 20)
fi

# Display the output using Jamf Helper with a timeout of 30 seconds
"$JAMF_HELPER" -windowType utility \
-title "Disk Usage Report" \
-description "$output" \
-button1 "OK" \
-timeout 60