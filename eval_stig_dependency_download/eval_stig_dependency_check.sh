##################################################################################################
##################################################################################################
# Created by Sam Insanali
# GitHub: https://github.com/SInsanali
##################################################################################################
##################################################################################################
# Description:
# This script checks if packeges are installed and if not attempts to install them. 
##################################################################################################
##################################################################################################



#!/bin/bash

# Define colors
GREEN="\e[32m"
RED="\e[31m"
RESET="\e[0m"

# Function to check and install a package
check_and_install() {
    package=$1
    echo -e "\n[ + ] Checking if ${package} is installed..."
    
    if rpm -qa | grep -q "^${package}"; then
        echo -e "${GREEN}[ ✔ ] ${package} is installed.${RESET}"
    else
        echo -e "${RED}[ ! ] ${package} is not installed. Attempting to install...${RESET}"
        if sudo yum install -y "${package}"; then
            echo -e "${GREEN}[ ✔ ] ${package} successfully installed.${RESET}"
        else
            echo -e "${RED}[ ✖ ] Installation of ${package} failed. Please install it manually.${RESET}"
        fi
    fi
}

# Check for the packages 
check_and_install "libicu"
check_and_install "lshw"
