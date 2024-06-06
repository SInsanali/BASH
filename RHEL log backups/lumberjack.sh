#!/bin/bash

# Lumberjack Script: Automates the backup of specific log files in RHEL devices
# Created by Sam Insanali

# Default variables
default_servername="server_name"
default_labname="example_lab"
default_backup_dir="/opt/logbackup"
log_files="audit secure* messages* cron* boot*"
cron_job="/usr/local/bin/lumberjack.sh"

# Function to prompt and validate input
prompt_input() {
  local prompt_message=$1
  local default_value=$2
  local input

  read -p "$prompt_message [$default_value]: " input
  echo "${input:-$default_value}"
}

# Function to prompt and validate backup directory
prompt_backup_dir() {
  local valid_dir=0
  while [ $valid_dir -eq 0 ]; do
    echo -e "\033[32mThe default log backup directory is \033[31m$default_backup_dir\033[0m"
    echo -e "\033[32mTo keep this path, type \033[0m\033[31m'y'\033[0m\033[32m | To change the backup directory, type \033[0m\033[31m'n'\033[0m"
    read -r user_input

    if [ "$user_input" == "y" ]; then
      backup_dir=$default_backup_dir
      valid_dir=1
    elif [ "$user_input" == "n" ]; then
      echo -e "\033[32mEnter the backup directory:\033[0m"
      read -r user_input
      if [[ "$user_input" =~ ^/ ]]; then
        backup_dir=$user_input
        valid_dir=1
      else
        echo -e "\033[31mPlease enter a valid backup location format: /path/to/directory\033[0m"
      fi
    else
      echo -e "\033[31mInvalid input. Please type 'y' or 'n'.\033[0m"
    fi
  done
}

# Function to prompt for server name and lab name, and confirm the file name format
prompt_names() {
  local valid_names=0
  while [ $valid_names -eq 0 ]; do
    echo -e "\033[32mThe backup file will be formatted like this: \033[0m\033[32m_\033[31mservername\033[32m_\033[31mlabname\033[32m_YYYY-MM.tar.gz\033[0m"
    echo -e "\033[32mEnter the server name [\033[31mserver_name\033[32m]: \033[0m"
    read -r servername
    servername=${servername:-$default_servername}

    echo -e "\033[32mEnter the lab name [\033[31mexample_lab\033[32m]: \033[0m"
    read -r labname
    labname=${labname:-$default_labname}

    # Show an example of the archive name format
    example_archive_name="${servername}_${labname}_$(date +%Y-%m).tar.gz"
    echo -e "\033[32mExample archive name: $example_archive_name\033[0m"

    echo -e "\033[32mDo you want to proceed with this naming convention? (\033[31my\033[32m/\033[31mn\033[32m)\033[0m"
    read -r confirm
    if [ "$confirm" == "y" ]; then
      valid_names=1
    else
      echo -e "\033[31mLet's try again.\033[0m"
    fi
  done
}

# Check if the cron job exists
if crontab -l | grep -q "$cron_job"; then
  # If the cron job exists, read the backup directory from the cron job
  backup_dir=$(crontab -l | grep "$cron_job" | awk -F' ' '{print $7}' | sed 's,/usr/local/bin/lumberjack.sh,,')
  # Read the server name and lab name from the script
  servername=$(grep -E '^servername=' /usr/local/bin/lumberjack.sh | cut -d '=' -f 2)
  labname=$(grep -E '^labname=' /usr/local/bin/lumberjack.sh | cut -d '=' -f 2)
else
  # If the cron job does not exist, prompt the user for input
  prompt_names
  prompt_backup_dir
fi

# Get current year and month (and day if needed)
current_year=$(date +%Y)
current_month=$(date +%m)
#current_day=$(date +%d)
#remove the "#" if the day is needed in the file name of the backup

# Construct the filename for the tar archive
archive_name="${servername}_${labname}_${current_year}-${current_month}.tar.gz"
#archive_name="${servername}_${labname}_${current_year}-${current-month}-${current-day}.tar.gz" 
#remove the "#" if the day is needed in the file name of the backup AND comment out the other archive_name variable

# Move to the /var/log directory to start the archival process
cd /var/log || exit

# Output the starting message in green
echo -e "\033[32m\nLumber Jack is on site, getting to work\033[0m\n\n"

# Create the backup directory if it does not exist
mkdir -p "$backup_dir"

# Set permissions for the backup directory
chmod 600 "$backup_dir"

# Create the tar.gz archive and store it in the backup directory
tar -czvf "${backup_dir}/${archive_name}" ${log_files}

# Inform the user about the file name and storage location
echo -e "\033[32m\n\nYour file is named ${archive_name} and is stored here: ${backup_dir}\033[0m"

# Add the cron job without duplicating
if ! crontab -l | grep -q "$cron_job"; then
  # This sets the job to run at midnight on the 15th of each month
  # The cron job can be modified if backups are needed on a different interval
  (crontab -l; echo "0 0 15 * * $cron_job $backup_dir") | crontab -
fi

# Output the completion message in green
echo -e "\033[32m\nAll good here, heading out\033[0m\n"

# In case the script does not run:
# To remove Windows carriage returns
# use this command: 
# sed -i -e 's/\r$//' /path/to/lumberjack.sh
