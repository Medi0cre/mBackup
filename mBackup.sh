#!/bin/bash
####################################
#
# Backup to directory script.
#
####################################


#Declaring Variables:
#
#What to Backup
backupSourceDir="/home/"$(hostname -s)
#Where to Backup to (empty, gets filled by User-Input)
backupDestinationDir=""

#Boolean to switch betwen the 2 Backup-Types (Is set by User-Input later
fullBackupSwitch="true"

# Create archive filename.
day=$(date +%A)
hostname=$(hostname -s)
archive_file="$hostname-$day"

#Function to show the User what to Input
usage() {
        echo "Backup: $(basename $0) [-a -b]" 2>&1
        echo '   -a   <full|incremental>'
        echo '   -b   <destination>'
        exit 1
}

#Function to create Full-Backup at chosen Destination 
full_backup() {
	echo "Full-Backup will be created"
	rsync -av ${backupSourceDir} ${backupDestinationDir}/${archive_file}
	zip ${backupDestinationDir}/${archive_file}.zip ${backupDestinationDir}/${archive_file}/* 
}

#Function to create Incremental-Backup building on previous Full-Backup
incremental_backup() {
	echo "Incremental-Backup will be created"
	zip ${backupDestinationDir}/${archive_file}.zip ${backupSourceDir}/* && rsync -av ${backupDestinationDir}/${archive_file} /${backupDestinationDir}/

}

#The first Arguent switches the Backup-mode depending on User-Input [-a full /-a incremental]
#The second Argument is the Backup-Destination as chosen by the User. It gets passed allong into the function with the Variable (backupDestinationDir)
while getopts ":a:b:" arg;
do
    case "${arg}" in
        a)
        	a=${OPTARG}
        	((a == "full" || a == "incremental")) || usage
        	#sets the Bolean fullBackupSwitch
      		case "${a}" in
        		full)
        			fullBackupSwitch=true
        			;;
        		incremental)
        			fullBackupSwitch=false
        			;;	
        		*)	
        			usage
        			;;
        	esac
		;;
        b) 
        	backupDestinationDir=${OPTARG}
		;;
        *)	
        	#if the input was not correct the usage-Function gets called to show the User how to input Arguments
		usage
		;;
    esac
done
shift $((OPTIND-1))


#changes Backup-type depending on the boolean $fullBackupSwitch, executing the corresponding function (incremental_backup / full_backup)
if [ $fullBackupSwitch == false ]; then 
	incremental_backup
else
	full_backup	
fi

