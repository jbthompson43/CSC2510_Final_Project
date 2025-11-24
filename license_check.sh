#!/bin/bash

#script created in partnership with ChatGPT

LICENSE_FILE="$HOME/.sysdat_93820.dat"

# XOR
OBFUSCATED=(5 15 3 14 4 6 0 3 1 2 7 6 14 5 15 3)

function reconstruct_key {
    local result=""
    for num in "${OBFUSCATED[@]}"; do
        digit=$((num ^ 7))   # de-obfuscate by XORing again
        result+="$digit"
    done
    echo "$result"
}

VALID_KEY=$(reconstruct_key)

if [[ ! -f "$LICENSE_FILE" ]]; then
    echo "License file not found."
    read -s -p "Enter your 16-digit license key: "  USER_KEY
    echo ""
    if [[ "$USER_KEY" == "$VALID_KEY" ]]; then
        echo "Key Confirmed."
        echo "$USER_KEY" > "$LICENSE_FILE"
    else
        echo "Invalid license key. Exiting."
        exit 1
    fi
fi

echo "License verified. Program starting..."

