##################################################################################################
##################################################################################################
# Created by Sam Insanali
# GitHub: https://github.com/SInsanali
##################################################################################################
##################################################################################################
# Description:

# This script semi-automates the SCP process if a file needs to be moved to multiple hosts.
# It was created due to the lack of other methods to move files around efficently. 

# This version of the script requires the password to be manually entered for each host

##################################################################################################
##################################################################################################

#!/bin/bash

# Prompt for the file or directory to SCP
read -p "Enter the full path to the file or directory you want to SCP: " file_to_scp

# Validate file or directory existence
if [[ ! -e "$file_to_scp" ]]; then
    echo "Error: The specified file or directory does not exist."
    exit 1
fi

# Prompt for the username to use
read -p "Enter the username to use: " username

# Prompt for the destination path
read -p "Enter the destination path on the remote systems: " remote_path

# Define the list of remote IP addresses
declare -a remote_ips=(
    # input your IP addresses or hostnames below
    "192.168.1.1"
    "192.168.1.2"
    "192.168.1.3"
)

# Loop through each IP and prompt for password during SCP
for ip in "${remote_ips[@]}"; do
    echo "Starting SCP to $ip:$remote_path..."
    
    # SCP will prompt for the password manually
    scp -r "$file_to_scp" "$username@$ip:$remote_path"

    # Check if SCP was successful
    if [ $? -eq 0 ]; then
        echo "File successfully copied to $ip:$remote_path"
    else
        echo "Failed to copy file to $ip:$remote_path"
    fi
done
