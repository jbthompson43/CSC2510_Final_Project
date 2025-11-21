#!/bin/bash
# main.sh
# Main script with menu for user management operations

PARSER_SCRIPT="parse.sh"
USER_ADD_SCRIPT="user_add.sh"
OUTPUT_FILE="staff.txt"

# Source the user_add function
if [ ! -f "$USER_ADD_SCRIPT" ]; then
    echo "Error: $USER_ADD_SCRIPT not found" >&2
    exit 1
fi

source "$USER_ADD_SCRIPT"

show_menu() {
    echo "=== User Management Menu ==="
    echo "1) Add users from faculty list"
    echo "2) Add individual user"
    echo "3) Exit"
    echo -n "Select option: "
}

add_users() {
    if [ ! -f "$PARSER_SCRIPT" ]; then
        echo "Error: $PARSER_SCRIPT not found" >&2
        return 1
    fi

    echo "Running parser..."
    bash "$PARSER_SCRIPT"

    if [ ! -f "$OUTPUT_FILE" ]; then
        echo "Error: $OUTPUT_FILE was not created" >&2
        return 1
    fi

    echo "Adding users..."
    while IFS= read -r name; do
        if [ -n "$name" ]; then
            echo "Processing: $name"
            add_user "$name"
        fi
    done < "$OUTPUT_FILE"

    echo "Cleaning up..."
    rm -f "$OUTPUT_FILE"
    echo "Done."
}

add_individual_user() {
    echo -n "Enter first name: "
    read -r firstname
    echo -n "Enter last name: "
    read -r lastname
    if [ -z "$firstname" ] || [ -z "$lastname" ]; then
        echo "Error: No first or last name provided" >&2
        return 1
    fi
    local name="$firstname $lastname"
    echo "Adding user: $name"   
    add_user "$name"
    echo "Done."
}

# Main loop
while true; do
    show_menu
    read -r choice
    echo

    case $choice in
        1) add_users ;;
        2) add_individual_user ;;
        3) echo "Exiting..."; exit 0 ;;
        *) echo "Invalid option. Please try again." ;;
    esac
    echo
done

