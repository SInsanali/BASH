#!/bin/bash

##################################################################################################
##################################################################################################
# Created by Sam Insanali
# GitHub: https://github.com/SInsanali
##################################################################################################
##################################################################################################
# Description:
# This script lets you select a known SSH alias and connect via your ~/.ssh/config on AlmaLinux.
# It assumes your SSH configuration is properly set up with matching aliases.
##################################################################################################
##################################################################################################

# Define colors
GREEN="\e[32m"
RED="\e[31m"
RESET="\e[0m"

# Display notice
echo -e "\n${GREEN}#######################################################################${RESET}"
echo -e "${GREEN} ENSURE THE SSH ALIASES BELOW MATCH ENTRIES IN YOUR ~/.ssh/config FILE${RESET}"
echo -e "${GREEN}#######################################################################${RESET}\n"

# INSTRUCTIONS:
# Your ~/.ssh/config file should contain entries like the following:
#
# Host alias-1
#     HostName your.hostname.com
#     User your-username
#     IdentityFile ~/.ssh/your-key.pem
#
# Host alias-2
#     HostName another.host.com
#     User your-username
#     IdentityFile ~/.ssh/another-key.pem
#
# These aliases (alias-1, alias-2, etc.) should match exactly in the ALIASES array below.

# Define environment names and SSH aliases
NAMES=(
  "Environment_1"
  "Environment_2"
  "Environment_3"
  "Environment_4"
)

ALIASES=(
  "alias-1"
  "alias-2"
  "alias-3"
  "alias-4"
)

# Display environment options
echo -e "${GREEN}[ + ]${RESET} Select the environment to SSH into:"
printf "\n%-5s %-20s %-25s\n" "Num" "Name" "SSH Alias"
echo "---------------------------------------------------------------"

for i in "${!NAMES[@]}"; do
    num=$((i + 1))
    printf "%-5s %-20s %-25s\n" "$num" "${NAMES[$i]}" "${ALIASES[$i]}"
done

# Prompt for user input
read -p $'\n[ ? ] Enter the number of the host you want to SSH to: ' choice

# Validate choice
index=$((choice - 1))
if [[ "$choice" =~ ^[0-9]+$ ]] && (( choice >= 1 && choice <= ${#NAMES[@]} )); then
    echo -e "\n${GREEN}[ + ]${RESET} Connecting to ${ALIASES[$index]} ..."
    ssh "${ALIASES[$index]}"
else
    echo -e "\n${RED}[ ! ]${RESET} Invalid selection. Exiting."
    exit 1
fi
