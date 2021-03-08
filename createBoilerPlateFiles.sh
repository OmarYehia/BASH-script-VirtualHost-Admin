### This script contains functions to create boiler plate files
### Made by: Omar Yehia

### This function creates a boilerplate index.html file for a virtual host
### Arguments: Takes host name and creates an index file in it's directory
### Returns: Nothing
function createIndexFile {
	local HOST_NAME=${1}
	sudo touch /var/www/${HOST_NAME}/index.html
	sudo bash -c "echo '<h1>Welcome to ${HOST_NAME}</h1>' > /var/www/${HOST_NAME}/index.html"
}


### This function create a boilerplate .conf file for the host
### Arguments: Takes host name and creates .conf file
### Returns: Nothing
function createConfFile {
	local HOST_NAME=${1}
	local FILE_PATH=/etc/apache2/sites-available/${HOST_NAME}.com.conf
	sudo touch ${FILE_PATH}
	sudo bash -c "echo '<VirtualHost *:80>' >> ${FILE_PATH}"
	sudo bash -c "echo 'DocumentRoot /var/www/${HOST_NAME}' >> ${FILE_PATH}"
	sudo bash -c "echo 'ServerName ${HOST_NAME}.com' >> ${FILE_PATH}"
	sudo bash -c "echo '</VirtualHost>' >> ${FILE_PATH}"
	sudo bash -c "echo '<Directory /var/www/${HOST_NAME}>' >> ${FILE_PATH}"
	sudo bash -c "echo 'Options ALL' >> ${FILE_PATH}"
	sudo bash -c "echo 'AllowOverride All' >> ${FILE_PATH}"
	sudo bash -c "echo '</Directory>' >> ${FILE_PATH}"
}


### This function creates an empty .htaccess file
### Arguements: Takes the host name and creates the file -- example: create_htaccess omar
### Returns: Nothing -- All the file existing and permission checks are done in the main logic to avoid repetition
###		in the same main function if it needs to check for the file existance for multiple functions
function create_htaccess {
	local HOST_NAME=${1}
	local FILE_PATH=/var/www/${HOST_NAME}
	sudo touch ${FILE_PATH}/.htaccess
	sudo bash -c "echo 'AuthType Basic' >> ${FILE_PATH}/.htaccess"
        sudo bash -c "echo 'AuthName \"Private Area\"' >> ${FILE_PATH}/.htaccess"
        sudo bash -c "echo 'AuthUserFile /etc/apache2/.htpasswd' >> ${FILE_PATH}/.htaccess"
}


### This function creates .htpasswd file if it doesn't exist
function check_htpasswd_exist {
	local RESULT=$(ls /etc/apache2/.htpasswd)
	if [ ${?} -ne 0 ]
	then
		sudo touch /etc/apache2/.htpasswd
	fi
}
