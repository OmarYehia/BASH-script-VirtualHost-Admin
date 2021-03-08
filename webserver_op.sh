### This script contains the functions that control
### the installation and uninstallation of Apache webserver
### Made by: Omar Yehia (Open Source Intake 41 - ITI)

source checker.sh

## This function installs Apache on the machine
## Arguments: Apache version -- example: installWebServer 2
##	this will install apache2 on the machine
## Returns:
##	0:Successful installation
##	1:Apache already installed
function installWebServer {
	local VERSION=${1}
	## Check if apache exists
	isInstalled apache${VERSION}
	if [ ${?} -eq 1 ]
	then
		sudo apt install apache${VERSION}
		if [ ${?} -eq 100 ]
		then
			return 2
		else
			return 0
		fi
	else
		return 1
	fi
}

## This function removes Apache from the machine
## Arguments: Apache version -- example: removeWebServer 2
##      this will remove apache2 from the machine
## Returns:
##      0:Successful removal
##      1:apache webserver not found
function removeWebServer {
        local VERSION=${1}
        sudo service apache${VERSION} stop
	sudo apt purge apache${VERSION}
        if [ ${?} -eq 100 ]
        then
                return 1
        else
		sudo apt autoremove --purge
                return 0
        fi
}

