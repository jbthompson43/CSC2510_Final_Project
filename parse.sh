#!/bin/bash
# parse_tntech_faculty.sh
# Extracts clean faculty names (Firstname Lastname only) from TTU CSC faculty page.
# Saves results to a file.

#license check before running the file, prevents other files being run before
#the license check is made in main.sh
if [[ ! -f "$HOME/.sysdat_93820.dat" ]]; then
        echo "ERROR: License check failed. Run main.sh first."
        exit 1
fi

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
