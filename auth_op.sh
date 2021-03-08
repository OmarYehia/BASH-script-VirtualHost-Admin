### This script contains all the authentication operations
### It mainly checks for .htaccess and remove/add authentication to it
### Made by: Omar Yehia

source checker.sh
source createBoilerPlateFiles.sh

### Sentence Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;31m'
NC='\033[0m' # No color


### This functions adds authentication directive in the .htaccess file if exists and creates it if not
### Arguments: Takes user host name 
### Returns:
###	0:VirtualHost authentication successfully
###	1:VirtualHost doesn't exist
###	2:VirtualHost already has authentication
function enableAuthentication {
	local HOST_NAME=${1}
	doesDirectoryExist /var/www/${HOST_NAME}
        if [ ${?} -eq 1 ]
        then
                echo -e "${RED}ERROR: VirtualHost doesn't exist!${NC}"
                return 1
	else
		checkAuthentication ${HOST_NAME}
		local AUTH=${?}
		if [ ${AUTH} -eq 1 ]
		then
			echo -e "${YELLOW}This VirtualHost already has authentication!${NC}"
			return 2
		fi
		
		if [ ${AUTH} -eq 2 ] # Means the file doesn't exist
		then
			create_htaccess ${HOST_NAME}
			echo -e "${GREEN} File /var/www/${HOST_NAME}/.htaccess was created successfully!${NC}"
		fi
	fi

	check_htpasswd_exist ## Creates the .htpasswd  file if doesn't exist
	local FILE_PATH="/var/www/${HOST_NAME}/.htaccess"

	local CREATE_USER
	read -p "Would you like to create an authenticated user (y/n) ? " CREATE_USER
	if [ ${CREATE_USER} == "y" ]
	then
		local USER
		local USER_FLAG=0
		while [ ${USER_FLAG} -eq 0 ]
		do
			read -p "Please choose a username: " USER
			doesUserExist ${USER}
			if [ ${?} -eq 0 ]
			then
				local UPDATEUSER
				read -p "User already exist, would you like to update his password (y/n)? :" UPDATEUSER
				if [ ${UPDATEUSER} == "y" ]
				then
					sudo htpasswd /etc/apache2/.htpasswd ${USER}
					USER_FLAG=1
				fi
			else
				sudo htpasswd /etc/apache2/.htpasswd ${USER}
				USER_FLAG=1
			fi
		done
	fi

	### Adding the directive to .htaccess
	sudo bash -c "echo 'Require valid-user' >> ${FILE_PATH}"
	echo -e "${GREEN}Authentication enabled successfully!${NC}"
	echo -e "${YELLOW}If the authentication isn't working on your current browser try using incognito mode  to test the authentication.${NC}"
	return 0
}


### This function disables the authentication from a VirtualHost
### Arguments: Takes the host name as an argument -- example: disableAuthentication omar
### Returns:
###	0:VirtualHost authentication disabled successfully
###	1:VirtualHost doesn't have authentication
function disableAuthentication {
	local HOST_NAME=${1}

        doesDirectoryExist /var/www/${HOST_NAME}
	if [ ${?} -eq 1 ]
        then
                echo -e "${RED}ERROR: VirtualHost doesn't exist!${NC}"
                return 1
        else
                checkAuthentication ${HOST_NAME}
                local AUTH=${?}
                if [ ${AUTH} -eq 0 ] || [ ${AUTH} -eq 2 ]
                then
                        echo -e "${YELLOW}This VirtualHost already has authentication disabled!${NC}"
                        return 1
		else
			sudo bash -c "sudo sed -i '/Require valid-user/d' /var/www/${HOST_NAME}/.htaccess"
			echo -e "${GREEN}Authentication disabled successfully!${NC}"
			return 0
                fi
        fi
}
