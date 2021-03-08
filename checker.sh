### This file contains all the checkers used in this application
### Made by: Omar Yehia

### This function checks if a program is installed on the machine or not
### Arguments: Name of the program -- example: isInstalled apache2
### Returns:
###	0:The program is installed
###	1:The program doesn't exist
function isInstalled {
	local PROG_NAME=${1}
	local RESULT=$(which ${PROG_NAME} | wc -l)
	if [ ${RESULT} -eq 1 ]
	then
		return 0
	else
		return 1
	fi
}


### This function checks whether a directory exists or not
### Arguments: Takes path directory -- example: doesDirectoryExist /etc
### Returns:
###	0:Directory exists
###	1:Directory doesn't exist
function doesDirectoryExist {
	local DIRECTORY_PATH=${1}
	[ ! -d ${DIRECTORY_PATH} ] && return 1
	return 0
}


### This function checks a file exists or not
### Arguments: Takes path to file -- example: doesFileExist /etc/example
### Returns:
###     0:File exists
###     1:File doesn't exist
function doesFileExist {
        local FILE_PATH=${1}
        [ ! -f ${FILE_PATH} ] && return 1
        return 0
}


### This function checks .htpasswd file to see if a user already there or not
### Arguments: Takes a name to check if it exist -- example: doesUserExist "omar"
### Returns:
### 	0:User exists
###	1:User doesn't exist
function doesUserExist {
	local USER=${1}
	local NUMBER_OF_RESULTS=$(cat /etc/apache2/.htpasswd | cut -d ":" -f 1 | grep "^${USER}$" | wc -l)
	if [ ${NUMBER_OF_RESULTS} == 1 ]
	then
		return 0
	else
		return 1
	fi
}


### This function checks if the host currently has authentication required or not
### Arguments: Takes the host name as an argument -- example: checkAuthentication omar
### Returns:
###	0:No authentication found on the host
###	1:Authentication found on the host
###	2:Means .htaccess doesn't exist
function checkAuthentication {
        local HOST_NAME=${1}
        doesFileExist /var/www/${HOST_NAME}/.htaccess
        if [ ${?} -eq 1 ] # Means the file doesn't exist
        then
                return 2
        else
		local RESULT=$(cat /var/www/${HOST_NAME}/.htaccess | grep "^Require valid-user$" | wc -l)
		if [ ${RESULT} -eq 0 ]
		then
			return 0
		else
			return 1
		fi
        fi
}

