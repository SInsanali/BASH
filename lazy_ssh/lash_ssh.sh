#!/bin/bash

##################################################################################################
##################################################################################################
# Created by Sam Insanali
# GitHub: https://github.com/SInsanali
##################################################################################################
##################################################################################################
# Description:
# This script allows the user to select an environment to SSH into from a predefined list.
##################################################################################################
##################################################################################################

# Define colors
GREEN="\e[32m"
RED="\e[31m"
RESET="\e[0m"

# Define SSH environments (nicknames and hostnames)
# Format: [number]="Nickname:hostname"
declare -A ENVS=(
    #[1]="Dev:dev.example.com"
    #[2]="Staging:staging.example.com"
    #[3]="Prod:prod.example.com"
)

# Display environment options
echo -e "\n${GREEN}[ + ]${RESET} Select the environment to SSH into:"
printf "\n%-5s %-20s %-20s\n" "Num" "Name" "Hostname"
echo "----------------------------------------------------------"
for i in "${!ENVS[@]}"; do
    IFS=":" read -r name host <<< "${ENVS[$i]}"
    printf "%-5s %-20s %-20s\n" "$i" "$name" "$host"
done

# Prompt for input
read -p $'\n[ ? ] Enter the number of the host you want to SSH to: ' choice

# Validate selection
if [[ -z "${ENVS[$choice]}" ]]; then
    echo -e "\n${RED}[ ! ]${RESET} Invalid selection. Exiting."
    exit 1
fi

# Extract hostname and connect
selected="${ENVS[$choice]}"
hostname="${selected#*:}"
echo -e "\n${GREEN}[ + ]${RESET} Connecting to $hostname ..."
ssh "$hostname"
