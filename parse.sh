#!/bin/bash
# parse_tntech_faculty.sh
# Extracts clean faculty names (Firstname Lastname only) from TTU CSC faculty page.
# Saves results to a file.

URL="https://www.tntech.edu/engineering/programs/csc/faculty-and-staff.php"
OUTPUT="staff.txt"

# Download webpage HTML
html=$(curl -s "$URL")

# looks for strings between <h4><strong> and </strong></h4>
echo "$html" | grep -oP '(?<=<h4><strong>).*?(?=</strong></h4>)' |
while read -r raw_name; do
    # isolate names
    clean_name=$(echo "$raw_name" | \
        sed 's/&nbsp;//g' | \
        sed 's/<br>//g' | \
        sed 's|</strong><strong>||g' | \
        sed 's/Ph\.D\.//Ig' | \
        sed 's/Dr\.//Ig' | \
        sed 's/Professor//Ig' | \
        sed 's/,//g' | \
        sed 's/[[:space:]]\+/ /g' | \
        sed 's/^[ \t]*//;s/[ \t]*$//')

    if [ -n "$clean_name" ]; then
        echo "$clean_name" >> "$OUTPUT"
    fi
done
