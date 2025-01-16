#!/bin/bash

# System Information Collector Script: Automates collection of critical system information on RHEL devices
# Created by Sam Insanali

# Configuration
homedir="/home/$(whoami)"
output_dir="System_Info_Collection"
hostname="$(hostname)"

# Function to collect system information
collect_info() {
  local temp_dir="$homedir/$output_dir"
  local zip_dir="$homedir/${hostname}_System_Info"
  mkdir -p "$temp_dir"
  mkdir -p "$zip_dir"

  echo -e "\n\033[37m[ - ] Starting Host Information Collection\033[0m"
  cat /etc/hosts > "$temp_dir/${hostname}_hosts.txt"
  echo -e "\033[32m[ + ] Completed Host Information Collection\033[0m"

  echo ""

  echo -e "\033[37m[ - ] Starting Installed Software Collection\033[0m"
  rpm -qa --last > "$temp_dir/${hostname}_software.txt"
  echo -e "\033[32m[ + ] Completed Installed Software Collection\033[0m"

  echo ""

  echo -e "\033[37m[ - ] Starting Port Information Collection\033[0m"
  netstat -an > "$temp_dir/${hostname}_ports.txt"
  echo -e "\033[32m[ + ] Completed Port Information Collection\033[0m"

  echo ""

  echo -e "\033[37m[ - ] Starting Running Processes Collection\033[0m"
  ps -aux > "$temp_dir/${hostname}_processes.txt"
  echo -e "\033[32m[ + ] Completed Running Processes Collection\033[0m"

  echo ""

  echo -e "\033[37m[ - ] Starting Services Collection\033[0m"
  systemctl list-unit-files --type=service > "$temp_dir/${hostname}_services.txt"
  echo -e "\033[32m[ + ] Completed Services Collection\033[0m"

  echo ""

  echo -e "\033[37m[ - ] Starting Network Adapter Information Collection\033[0m"
  ip addr show > "$temp_dir/${hostname}_network_adapters.txt"
  echo -e "\033[32m[ + ] Completed Network Adapter Information Collection\033[0m"

  echo ""

  echo -e "\033[37m[ - ] Preparing files for compression\033[0m"
  mv "$temp_dir"/*.txt "$zip_dir/"
  rmdir "$temp_dir"
  echo -e "\033[32m[ + ] File preparation completed\033[0m"

  echo ""

  echo -e "\033[37m[ - ] Compressing the collected data\033[0m"
  cd "$homedir" && zip -r "${hostname}_System_Info.zip" "$(basename $zip_dir)" > /dev/null 2>&1
  echo -e "\033[32m[ + ] Data compression completed\033[0m"

  echo ""

  echo -e "\033[37m[ - ] Cleaning up temporary files\033[0m"
  rm -rf "$zip_dir"
  echo -e "\033[32m[ + ] Cleanup completed\033[0m"
}

# Begin information collection
echo -e "\033[37m[ ! ] Starting System Information Collection\033[0m"
collect_info
echo -e "\n\033[32m[ ! ] System information collection is complete. Check the file: $homedir/${hostname}_System_Info.zip\033[0m"
