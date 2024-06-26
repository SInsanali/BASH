#!/bin/bash

# The Log Clean Up Script is used to mount a device and move backup files to the mounted device on Red Hat Enterprise Linux Systems
# Scripted to work in conjunction with the Lumberjack script
# Created by Sam Insanali

# Define the backup source directory by extracting it from the crontab
cron_job="/usr/local/bin/lumberjack.sh"
backup_location=$(crontab -l | grep "$cron_job" | awk '{print $7}')

# Ensure backup_location is set
if [ -z "$backup_location" ]; then
  echo -e "\033[31m\nError: Could not determine the backup location from the crontab.\033[0m"
  exit 1
fi

# Function to prompt and validate backup destination
prompt_backup_destination() {
  local valid_dir=0
  while [ $valid_dir -eq 0 ]; do
    echo -e "\033[32mThe current backup destination is \033[31m$backup_destination\033[0m"
    echo -e "\033[32mTo keep this path, type \033[0m\033[31m'y'\033[0m\033[32m | To change the backup destination, type \033[0m\033[31m'n'\033[0m"
    read -r user_input

    if [ "$user_input" == "y" ]; then
      valid_dir=1
    elif [ "$user_input" == "n" ]; then
      echo -e "\033[32mEnter the new backup destination:\033[0m"
      read -r user_input
      if [[ "$user_input" =~ ^/ ]]; then
        backup_destination=$user_input
        valid_dir=1
      else
        echo -e "\033[31mPlease enter a valid backup destination format: /path/to/directory\033[0m"
      fi
    else
      echo -e "\033[31mInvalid input. Please type 'y' or 'n'.\033[0m"
    fi
  done
}

# Default backup destination
backup_destination="/media/logbackups"

# Prompt the user to confirm or change the backup destination
prompt_backup_destination

# Display available block devices
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

  echo -e "\033[32m\nFiles moved successfully.\033[0m"

  # Unmount drive 
  umount /media
  echo -e "\033[32m\n$partition_name unmounted successfully.\033[0m"

else
  echo -e "\033[31m\nFailed to mount the device. Please check the partition name and try again.\033[0m"
fi

# Completion message
echo -e "\033[32m\nFile transfer operation completed.\033[0m"
