#!/bin/bash

# The Log Clean Up Script is used to mount a device and move backup files to the mounted device on Red Hat Enterprise Linux Systems
# Created by Sam Insanali

# Define the backup source directory
backup_location="/opt/logbackup"
file_name=$(ls $backup_location)

# Define the mount point for the removable media
backup_destination="/media/logbackups"

echo -e "\033[32m\nAvailable block devices:\033[0m"
lsblk

# Ask for the user's input on which partition to mount
read -p "Which partition would you like to mount? (e.g., sdb1): " partition_name

# Attempt to mount the partition
echo -e "\033[32m\nMounting /dev/${partition_name} to /media...\033[0m"
mount /dev/${partition_name} /media

# Check if the mount was successful
if mountpoint -q /media; then
    echo -e "\033[32m\nMounted successfully.\033[0m"
    
    # Move the files from backup location to backup destination
    echo -e "\033[32m\nMoving files from ${backup_location} to ${backup_destination}...\033[0m"
    mv ${backup_location}/* ${backup_destination}/

    echo -e "\033[32m\n$file_name moved successfully.\033[0m"

    #unmount drive 
    umount /media
    echo -e "\033[32m\n$partition_name umounted successfully.\033[0m"

else
    echo -e "\033[32m\nFailed to mount the device. Please check the partition name and try again.\033[0m"
fi

# Completion message
echo -e "\033[32m\nFile transfer operation completed.\033[0m"
