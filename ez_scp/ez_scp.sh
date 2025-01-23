##################################################################################################
##################################################################################################
# Created by Sam Insanali
# GitHub: https://github.com/SInsanali
##################################################################################################
##################################################################################################
# Description:
# This script semi-automates the SCP process if a file needs to be moved to multiple hosts.
# It uses `sshpass` to automate password entry. If `sshpass` is not installed, it installs it.
##################################################################################################
##################################################################################################

#!/bin/bash

# Check if sshpass is installed
if ! command -v sshpass &> /dev/null; then
    echo "sshpass not found. Attempting to install it..."
    if [[ -n "$(command -v apt-get)" ]]; then
        echo "Detected Debian-based system. Installing sshpass using apt-get..."
        sudo apt-get update && sudo apt-get install -y sshpass
    elif [[ -n "$(command -v yum)" ]]; then
        echo "Detected RHEL-based system. Installing sshpass using yum..."
        sudo yum install -y sshpass
    elif [[ -n "$(command -v brew)" ]]; then
        echo "Detected macOS. Installing sshpass using Homebrew..."
        brew install sshpass
    else
        echo "Error: Package manager not detected. Install sshpass manually and try again."
        exit 1
    fi

    if ! command -v sshpass &> /dev/null; then
        echo "Error: Failed to install sshpass. Exiting."
        exit 1
    fi

    echo "sshpass installed successfully."
fi

# Prompt for the file or directory to SCP
read -p "Enter the full path to the file or directory you want to SCP: " file_to_scp

# Validate file or directory existence
if [[ ! -e "$file_to_scp" ]]; then
    echo "Error: The specified file or directory does not exist."
    exit 1
fi

# Prompt for the username to use
read -p "Enter the username to use: " username

# Prompt for the password
read -s -p "Enter the password: " password
echo

# Prompt for the destination path
read -p "Enter the destination path on the remote systems: " remote_path

# Define the list of remote IP addresses
declare -a remote_ips=(
    # Input your IP addresses or hostnames below
    "192.168.1.1"
    "192.168.1.2"
    "192.168.1.3"
)

# Arrays to track successes and failures
successful_hosts=()
unsuccessful_hosts=()

# Loop through each IP and use sshpass for SCP
for ip in "${remote_ips[@]}"; do
    echo "Starting SCP to $ip:$remote_path..."
    
    # Use sshpass to automate password entry for SCP
    sshpass -p "$password" scp -r "$file_to_scp" "$username@$ip:$remote_path"

    # Check if SCP was successful
    if [ $? -eq 0 ]; then
        echo "File successfully copied to $ip:$remote_path"
        successful_hosts+=("$ip")
    else
        echo "Failed to copy file to $ip:$remote_path"
        unsuccessful_hosts+=("$ip")
    fi
done

# Display the results
echo
echo "##############################"
echo "SCP Summary:"
echo "##############################"
echo "Successful transfers:"
for host in "${successful_hosts[@]}"; do
    echo "- $host"
done

echo
echo "Unsuccessful transfers:"
for host in "${unsuccessful_hosts[@]}"; do
    echo "- $host"
done
