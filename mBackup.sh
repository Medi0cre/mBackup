#!/bin/bash
####################################
#
# Backup to directory script.
#
####################################


# What to backup. 
backup_files="/home"

fullBackupSwitch="true"

# Create archive filename.
day=$(date +%A)
hostname=$(hostname -s)
archive_file="$hostname-$day.tgz"

usage() {
        echo "Backup: $(basename $0) [-a -b]" 2>&1
        echo '   -a   <full|incremental>'
        echo '   -b   <destination>'
        exit 1
}

full_backup() {
	echo "Full-Backup will be created";
	tar -czf ${b}/$archive_file $backup_files;
	echo $b/$archive_file $backup_files;

}

incremental_backup() {
	echo "Incremental-Backup will be created"
	tar -czf $b/$archive_file $backup_files
}


while getopts ":a:b:" arg;
do
    case "${arg}" in
        a)
        	a=${OPTARG}
        	((a == "full" || a == "incremental")) || usage
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
        	b=${OPTARG}
		;;
        *)	
		usage
		;;
    esac
done
shift $((OPTIND-1))


if [ -z "${a}" ] || [ -z "${b}" ]; then
    usage
fi

if [ $fullBackupSwitch == false ]; then 
	 incremental_backup
else
	full_backup	
fi

