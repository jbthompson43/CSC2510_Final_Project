#!/bin/bash
# user_add.sh
# Function to add a user based on name pattern
# For testing: echoes the command instead of executing it

#license check before running the file, prevents other files being run before
#the license check is made in main.sh
if [[ ! -f "$HOME/.sysdat_93820.dat" ]]; then
	echo "ERROR: License check failed. Run main.sh first."
	exit 1
fi

CREDENTIAL_FILE="./user_credentials.txt"
touch "$CREDENTIAL_FILE"
chmod 600 "$CREDENTIAL_FILE"

add_user() {
    local full_name="$1"

    if [[ -z "$full_name" ]]; then
        echo "Error: No name provided" >&2
        return 1
    fi

    local firstname lastname username password

    # Extract firstname (field 1)
    firstname=$(awk '{print tolower($1)}' <<< "$full_name")

    # Extract lastname (fields 2...NF)
    lastname=$(awk '{
        for (i = 2; i <= NF; i++) {
            printf "%s", tolower($i)
        }
    }' <<< "$full_name")

    username="${firstname}.${lastname}"

    # Generate secure 12-char password
    password=$(tr -dc 'A-Za-z0-9!@#$%&*' </dev/urandom | head -c 12)

    # Create user (only once!)
    if ! id "$username" &>/dev/null; then
        useradd -m -s /bin/bash -c "$full_name" "$username"
        echo "$username:$password" | chpasswd
    else
        echo "Warning: User '$username' already exists, skipping useradd."
    fi

    # Remove old duplicate credential lines
    sed -i "/^${username}:/d" "$CREDENTIAL_FILE"

    # Append correctly formatted line
    echo "${username}:${password}" >> "$CREDENTIAL_FILE"

    echo "Created: $username"
}
