#!/bin/bash

# Lumberjack Script: Automates the backup of specific log files in RHEL devices
#Created by Sam Insanal

# User-defined variables for server number/name and lab name
servername="1"
labname="example_lab"

# Directory to store the log backups
backup_dir="/opt/logbackup"

# Logs to be archived
log_files="audit secure* messages* cron* boot*"

# Get current year and month (and day if needed)
current_year=$(date +%Y)
current_month=$(date +%m)
#current_day=$(date +%d)
#remove the "#" if the day is needed in the file name of the backup

# Construct the filename for the tar archive
archive_name="${servername}_${labname}_${current_year}-${current_month}.tar.gz"
#archive_name="${servername}_${labname}_${current_year}-${current_month}-${current_day}.tar.gz" 
#remove the "#" if the day is needed in the file name of the backup AND comment out the other archive_name variable


# Move to the /var/log directory to start the archival process
cd /var/log

# Output the starting message in green
echo -e "\033[32m\nLumber Jack is on site, getting to work\033[0m\n\n"

# Create the backup directory if it does not exist
mkdir -p "$backup_dir"

# Set permissions for the backup directory
chmod 600 "$backup_dir"

# Create the tar.gz archive and store it in the backup directory
tar -czvf "${backup_dir}/${archive_name}" ${log_files}

# Inform the user about the file name and storage location
echo -e "\033[32m\n\nYour file is named ${archive_name} and is stored here: ${backup_dir}"

# Add the cron job without duplicating
if [ ! "$(grep lumberjack.sh /var/spool/cron/root)" ]; then
	#this sets the job run at midnight on the 15th of each month
	#cron job can be modified if backups are needed on a different interval
	echo "0 0 15 * * /usr/local/bin/lumberjack.sh" >> /var/spool/cron/root
fi

# Output the completion message in green
echo -e "\nAll good here, heading out\033[0m\n"

# In the case of the script not running:
# to remove Windows carriage returns
# use this command: 
# sed -i -e 's/\r$//' /path/to/lumberjack.sh
