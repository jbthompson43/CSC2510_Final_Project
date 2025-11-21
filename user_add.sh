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

add_user() {
    local full_name="$1"
    
    if [ -z "$full_name" ]; then
        echo "Error: No name provided" >&2
        return 1
    fi
    
    # Extract firstname and lastname
    # Username: first.last (firstname.lastname)
    # Password: firstnamelastnameDEELTECH
    local firstname=$(echo "$full_name" | awk '{print $1}' | tr '[:upper:]' '[:lower:]')
    local lastname=$(echo "$full_name" | awk '{for(i=2;i<=NF;i++) printf "%s", $i (i<NF?"":""); print ""}' | tr '[:upper:]' '[:lower:]' | sed 's/[[:space:]]//g')
    
    # Generate username: firstname.lastname
    local username="${firstname}.${lastname}"
    
    # Generate password: firstnamelastnameDEELTECH (all lowercase name + DEELTECH)
    local password="${firstname}${lastname}DEELTECH"
    
    useradd -m -s /bin/bash -c "$full_name" "$username"
    echo "$username:$password" | chpasswd
}

