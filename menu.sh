#### This script contains all the menu operations
#### Made by: Omar Yehia (OS Intake 41 - ITI)

source webserver_op.sh
source displayFolderContents.sh
source virtualhost_op.sh
source auth_op.sh

### Coloring the sentence
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

### This function displays the menu on the shell
##  Takes no arguments and doesn't return anything
function displayMenu {
	echo " ___________________________________"
	echo -e "|${YELLOW}---------WEBSERVER ADMIN-----------${NC}|"
	echo "|   1- Install Apache2 Webserver    |"
	echo "|   2- Remove Apache2 Webserver     |"
	echo "|-----------------------------------|"
	echo -e "|${YELLOW}---------VIRTUALHOST ADMIN---------${NC}|"
	echo "|   3- List all Virtualhosts        |"
	echo "|   4- Add Virualhost               |"
	echo "|   5- Delete Virtualhost           |"
	echo "|   6- Enable Virtualhost           |"
	echo "|   7- Disable Virtualhost          |"
	echo "|-----------------------------------|"
        echo -e "|${YELLOW}-------AUTHINTICATION ADMIN--------${NC}|"
	echo "|   8- Enable Authintication        |"
	echo "|   9- Disable Authintication       |"
	echo "|___________________________________|"
}

### This function is responsible for menu operations when a user types a key
##  Takes no arguments and returns nothing
function runMenu {
	local FLAG=1
	local CH
	while [ ${FLAG} -eq 1 ]
	do
		read -p "Choose an operation (or type 'quit' to exit): " CH
		case ${CH} in
			"1")
				local VERSION
				read -p "Which version would you like to install: " VERSION
				installWebServer ${VERSION}
				INSTALL_CODE=${?}
				if [ ${INSTALL_CODE} -eq 0 ]
				then
					echo -e "${GREEN}Successfully Installed!${NC}"
				else
					if [ ${INSTALL_CODE} -eq 1 ]
					then
						echo -e "${YELLOW}Apache${VERSION} is already installed${NC}"
					else
						echo -e "${RED}ERROR: There's no apache version that corresponds to your selection!${NC}"
					fi
				fi
				;;
			"2")
				local VERSION
				read -p "Please add the apache version to confirm uninstallation (THIS CAN'T BE UNDONE): " VERSION
				removeWebServer ${VERSION}
				if [ ${?} -eq 0 ]
				then
					echo -e "${GREEN}Successfully removed!${NC}"
				else
					echo -e "${RED}ERROR: Apache${VERSION} is not found on your machine!${NC}"
				fi
				;;
			"3")
				doesDirectoryExist /etc/apache2/sites-available
				if [ ${?} -eq 1 ]
				then
					echo -e "${RED}Directory /etc/apache2/sites-available doesn't exist${NC}"
				else
					echo "VirtualHosts available on this machine:"
					echo "---------------------------------------"
					displayFolderContents /etc/apache2/sites-available
					if [ ${?} -eq 1 ]
					then
						echo -e "${YELLOW}No VirtualHosts found on this machine${NC}"
					fi
				fi
				;;
			"4")
				local VH_NAME
				read -p "Please enter the VirtualHost name: " VH_NAME
				addVirtualHost ${VH_NAME}
				;;
			"5")
				read -p "Please enter the VirtualHost name that you wish to delete (THIS ACTION IS NOT UNDOABLE): " VH_NAME
				deleteHost ${VH_NAME}
				;;
			"6")
				read -p "Please enter the VirtualHost that you wish to enable: " VH_NAME
				enableHost ${VH_NAME}
				;;
			"7")
				read -p "Please enter the VirtualHost that you wish to disable: " VH_NAME
				disableHost ${VH_NAME}
				;;
			"8")
				read -p "Please enter the VirtualHost that you wish to add authentication for: " VH_NAME
				enableAuthentication ${VH_NAME}
				;;
			"9")
				read -p "Please enter the VirtualHost that you wish to disable authentication from: " VH_NAME
				disableAuthentication ${VH_NAME}
				;;
			"quit")
				FLAG=0
				echo "Bye!"
		esac
	if [ ${FLAG} -eq 1 ]
	then
		displayMenu
	fi
	done
}

displayMenu
runMenu
