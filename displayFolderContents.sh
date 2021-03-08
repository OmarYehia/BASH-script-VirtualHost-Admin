### This script lists all the contents of a folder
### Made by: Omar Yehia
### Arguments: Takes the path of the folder -- example: displayFolderContents /etc
### Returns:
###	0:Folder is not empty and displays it's contents
###	1:Folder is empty
function displayFolderContents {
	local FOLDER_PATH=${1}
	local NUM_FILES=$(ls ${FOLDER_PATH} | column -t | wc -l)
	if [ ${NUM_FILES} -eq 0 ]
	then
		return 1
	else
		ls ${FOLDER_PATH} | column -t
		return 0
	fi
}
