#!/bin/bash
# remove_faculty.sh
# Separate script to remove faculty users (not part of assignment)
# Removes all users that were added from the faculty list

PARSER_SCRIPT="parse.sh"
OUTPUT_FILE="staff.txt"

# Function to remove a user based on name pattern
remove_user() {
    local full_name="$1"
    
    if [ -z "$full_name" ]; then
        echo "Error: No name provided" >&2
        return 1
    fi
    
    # Generate username using same pattern as add_user
    # Username: first.last (firstname.lastname)
    local firstname=$(echo "$full_name" | awk '{print $1}' | tr '[:upper:]' '[:lower:]')
    local lastname=$(echo "$full_name" | awk '{for(i=2;i<=NF;i++) printf "%s", $i (i<NF?"":""); print ""}' | tr '[:upper:]' '[:lower:]' | sed 's/[[:space:]]//g')
    local username="${firstname}.${lastname}"
    
    userdel -r "$username" 2>/dev/null || echo "User $username not found"
}

# Run parser to get current faculty list
if [ ! -f "$PARSER_SCRIPT" ]; then
    echo "Error: $PARSER_SCRIPT not found" >&2
    exit 1
fi

echo "Running parser to get faculty list..."
bash "$PARSER_SCRIPT"

if [ ! -f "$OUTPUT_FILE" ]; then
    echo "Error: $OUTPUT_FILE was not created" >&2
    exit 1
fi

echo "Removing faculty users..."
while IFS= read -r name; do
    if [ -n "$name" ]; then
        echo "Processing: $name"
        remove_user "$name"
    fi
done < "$OUTPUT_FILE"

echo "Cleaning up..."
rm -f "$OUTPUT_FILE"
echo "Done."

