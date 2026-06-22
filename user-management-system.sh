#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

LOG_FILE="user_management.log"
log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

log_message "Script Started"


while true
do 

Line="======================================"

echo -e "${BLUE} $Line"
echo "      User Management System "
echo -e "$Line ${NC}"
echo 
echo "1. Add User"
echo "2. Delete User"
echo "3. Lock User"
echo "4. Unlock User"
echo "5. List Users"
echo "6. Exit"
echo

read -p "Enter Your choice " choice
case $choice in 
    1)
        read -p "Enter Username: " username
        if id "$username" &>/dev/null
        then
            echo "User already exists."
        else
            sudo useradd "$username"
            sudo passwd "$username"
            if [[ $? -eq 0 ]]
                then
                    echo -e "${GREEN}User ${username} Created successfully. ${NC}"
                    log_message "User $username created"
                else
                    echo -e  "${RED}Failed to create user${NC}"
            fi  
        fi

        ;;
    2)
        read -p "Enter Username to delete: " username
        
        if id "$username" &>/dev/null
        then
            sudo userdel "$username"

            if [[ $? -eq 0 ]]
            then
                echo -e "${GREEN}User $username deleted successfully. ${NC}"
                log_message "User $username deleted"
            else
                echo -e "${RED}Failed to delete user.${NC}"
            fi
        else
            echo -e "${YELLOW}User does not exist${NC}"
        fi
        ;;
    3)
        read -p "Enter Username to Lock: " username

        if id "$username" &>/dev/null
        then
            sudo passwd -l "$username"
            if [[ $? -eq 0 ]]
            then
                echo -e "${GREEN}User $username locked successfully${NC}"
                log_message "User $username locked"
            else
                echo -e "${RED}Failed to lock User.${NC} "
            fi 
        else
            echo -e "${YELLOW}User does not exist.${NC} "
        fi 
        ;;
    4)
        read -p "Enter Username to unlock: " username

        if id "$username" &>/dev/null
        then
            sudo passwd -u "$username"

            if [[ $? -eq 0 ]]
            then
                echo -e "${GREEN}User $username unlock successfully.${NC} "
                log_message "User $username unlocked"
            else 
                echo -e "${RED}Failed to unlock User.${NC} "
            fi 
        else 
            echo -e "${YELLOW}User does not exist${NC}"
        fi 
        ;;
    5)
        echo "Normal Users: "
        awk -F: '$3 >= 1000 {print $1}' /etc/passwd
        ;;
    6)
        echo -e "${BLUE}Goodbye!${NC}"
        exit 0
        ;;
    *)
        echo "invailid Choice"
        ;;
esac
echo 
read -p "Please Enter to Continue... "
clear;
done
