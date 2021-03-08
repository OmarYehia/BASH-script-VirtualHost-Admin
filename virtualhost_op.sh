### This script contains all the functions to manipulate VirtualHosts
### Made by: Omar Yehia

source checker.sh
source createBoilerPlateFiles.sh

### Sentence Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;31m'
NC='\033[0m' # No color

## This function adds a virtual host bu following certain steps
## Arguments: Takes the host name that you wish to add -- example: addVirtualHost TestBash
## Returns:
##	0:Successfully created virtualhost
##	1:VirtualHost already exists
## You can test whether it's created or not by typing 'www.<The name you choose>.com' in the browser
function addVirtualHost {
	HOST_NAME=${1}
	doesDirectoryExist /var/www/${HOST_NAME}
	if [ ${?} -eq 0 ]
	then
		echo -e "${RED}ERROR: VirtualHost already exists!${NC}"
		return 1
	else
		sudo mkdir /var/www/${HOST_NAME}
		local MK_INDEX
		read -p "Would you like to create a default index.html? (y/n) " MK_INDEX
		if [ ${MK_INDEX} == "y" ]
		then
			createIndexFile ${HOST_NAME}
			echo -e "${GREEN}Index file created successfully!${NC}"
		fi
		# This creates .conf file in sites-available
		createConfFile ${HOST_NAME}
		# This adds site name to /etc/hosts file
		addToHosts ${HOST_NAME}
		echo -e "${GREEN}Site added to hosts file successfully!${NC}"
		enableHost ${HOST_NAME}
		sudo systemctl start apache2
		if [ ${?} == 0 ]
		then	
			sudo systemctl reload apache2
			echo -e "${GREEN}Apache2 restarted successfully!${NC}"
		fi
	fi
	return 0
}

## This functions enables the created virtualhost
## Arguments: Takes the virtualhost name -- example: enableHost TestBash
## Returns:
##	0:Successfully enabled
##	1:VirtualHost doesn't exist
##	2:VirtualHost already enabled
function enableHost {
	local HOST_NAME=${1}
	doesFileExist /etc/apache2/sites-available/${HOST_NAME}.com.conf
	if [ ${?} -eq 1 ]
	then
		echo -e "${RED}ERROR: VirtualHost doesn't exist${NC}"
		return 1
	else
		local RESULT=$(sudo a2ensite ${HOST_NAME}.com.conf | wc -l)
		if [ ${RESULT} -eq 1 ]
		then
			echo -e "${YELLOW}NOTICE: Site is already enabled!${NC}"
			return 2
		else
			echo -e "${GREEN}Site enabled Succesfully!${NC}"
			return 0
		fi
	fi
}

## This functions disables a virtualhost
## Arguments: Takes the virtualhost name -- example: disableHost TestBash
## Returns:
##      0:Successfully disabled
##      1:VirtualHost doesn't exist
##      2:VirtualHost already disabled
function disableHost {
        local HOST_NAME=${1}
        doesFileExist /etc/apache2/sites-available/${HOST_NAME}.com.conf
        if [ ${?} -eq 1 ]
        then
                echo -e "${RED}ERROR: VirtualHost doesn't exist!${NC}"
                return 1
        else
                local RESULT=$(sudo a2dissite ${HOST_NAME}.com.conf | wc -l)
                if [ ${RESULT} -eq 1 ]
                then
                        echo -e "${YELLOW}NOTICE: Site is already disabled!${NC}"
                        return 2
                else
                        echo -e "${GREEN}Site disabled Succesfully!${NC}"
                        return 0
                fi
        fi
}


## This functions adds a certain host to /etc/hosts
## Arguments: Takes the host name -- example: addtoHosts TestBASH
## Returns: Nothing
function addToHosts {
	local HOST_NAME=${1}
	sudo bash -c "echo '127.0.0.1	${HOST_NAME}.com' >> /etc/hosts"
}

## This function deletes a virtualhost
## Arguments: Takes the host name as an argument -- example: disableHost TestBash
## Returns:
##	0:Successfully removed
## 	1:VirtualHost doesn't exists
function deleteHost {
	local HOST_NAME=${1}
	doesFileExist /etc/apache2/sites-available/${HOST_NAME}.com.conf
        if [ ${?} -eq 1 ]
        then
                echo -e "${RED}ERROR: VirtualHost doesn't exist!${NC}"
                return 1
        else
                local RESULT=$(sudo a2dissite ${HOST_NAME}.com.conf | wc -l)
                if [ ${RESULT} -ne 1 ]
                then
                        echo -e "${GREEN}Site disabled Succesfully!${NC}"
                fi
		sudo rm /etc/apache2/sites-available/${HOST_NAME}.com.conf
        	echo -e "${GREEN}File removed from /etc/apache2/sites-available successfully!${NC}"
		
		doesDirectoryExist /var/www/${HOST_NAME}
		if [ ${?} -eq 0 ]
		then
			sudo rm -r /var/www/${HOST_NAME}
			echo -e "${GREEN}Folder removed from /var/www successfully!${NC}"
		fi

		## removes data from /etc/hosts
		sudo bash -c "sudo sed -i '/${HOST_NAME}.com$/d' /etc/hosts"
		echo -e "${GREEN}Host name removed successfully from /etc/hosts${NC}"
		return 0
        fi
}
