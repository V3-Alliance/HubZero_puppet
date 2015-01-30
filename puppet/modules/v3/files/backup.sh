#!/bin/sh

# backups of HUBZero are very hit and miss, by the look of it:
#    https://hubzero.org/answers/question/126
#    https://hubzero.org/answers/question/148
#
# however, hubzero at purdue uses dirvish and backula to manage their backups:
#    https://hubzero.org/resources/1376/download/IncidentResponse.pdf
#
# The automysqlbackup.sh package:
#   sudo apt-get install automysqlbackup.sh
#   sudo more /etc/default/automysqlbackup.sh
# and see: https://answers.launchpad.net/ubuntu/+source/automysqlbackup.sh/+question/248876
#
# And we should be copying accross users and groups
#   http://www.cyberciti.biz/faq/howto-move-migrate-user-accounts-old-to-new-server/
#


# backup host and user
#BACKUPHost=miro.hz.vpac.org
#BACKUPUser=hzbackup

#TODO: sort out backup key value
BACKUPKey=


# temporary directory
STORE=/home/debian/hzbackup

mkdir -p $STORE

PACKAGES=$STORE/packages
FILES=$STORE/config_files.tar.gz
DB=$STORE/db.dump
mysql_user_file=/home/debian/local_hz_mysql_user
WEBSITE=$STORE/varwwwsite.tar.gz
LDAP=$STORE/slapddump.ldif

HUBNAME=`awk '/site = / { print $3}' /etc/hubzero.conf`

# all the data will end up in this file
# format is "backup_<seconds since 1/1/1970>_<HUBNAME>_<day of the week>.tar.gz

HZ="backup_${HUBNAME}_`date +%A`.tar.gz"

# list of packages...

for i in `dpkg -l | awk '/^ii.*hubzero/ { print $2 }'`
        do
        echo $i >> $PACKAGES
done

# db...

# get mysql password from user
get_password() {
	read -p "MySQL credentials not found or invalid, enter MySQL user <root>: " user
	user=${user:-root}
	stty -echo
	read -p "Enter password for Mysql User $user: " pass
	stty echo
	echo $user $pass
}

# check mysql password
check_password() {
	user=$1
	pass=$2
	retval=-1
	if mysqladmin -u$user -p$pass ping 2>&1 | grep "mysqld is alive" > /dev/null 2>&1 ;
        	then retval=0
		else retval=1
	fi
	return $retval
}

# ensure we have a password for SQL to start with, substitute dummy to force interaction.
if [ ! -f $mysql_user_file -o ! -s $mysql_user_file ];
	then echo "sciu 8RvFeA38wrv5Z2" > $mysql_user_file
fi

# mysql_user_file is one line <username> <password>

sqlcred=`cat $mysql_user_file`
sqluser=$(echo $sqlcred | cut -d' ' -f1)
sqlpass=$(echo $sqlcred | cut -d' ' -f2)

if check_password $sqluser $sqlpass ;
	then continue
	else 
	# password in file is wrong
	rm $mysql_user_file
	count=1
	pass_correct=''
	while [ $count -lt 4 ]
		do
		sqlcred=$(get_password)
		echo
		sqluser=$(echo $sqlcred | cut -d' ' -f1)
		sqlpass=$(echo $sqlcred | cut -d' ' -f2)
		
		if check_password $sqluser $sqlpass;
			then echo "$sqluser $sqlpass" > $mysql_user_file ; pass_correct=true; break
			else 
			echo "password incorrect"
			count=$(expr $count + 1)
		fi
	done
	# get to here then all attempts to get a password exhausted . die.
	test $pass_correct || (echo "unable to proceed without correct password"; exit 1)
fi

# good so do the dump
mysqldump -u $sqluser -p$sqlpass $HUBNAME > $DB

# do ldap dump

/usr/sbin/slapcat -l $LDAP

# do website dump

tar zcf ${WEBSITE} /var/www/$HUBNAME/site 2>/dev/null

# files to backup

tar zcf $FILES --ignore-failed-read  2>/dev/null \
/etc/local_hz_mysql_root \
/etc/apt/sources.list \
/etc/hostname \
/etc/exim4 \
/etc/apache2 \
/etc/hub* \
/var/log/hubzero* \
/etc/logrotate.d/$HUBNAME-* \
/home/$HUBNAME \
/var/log/mw-service \
/etc/mw \
/var/log/vncproxy \
/var/log/mw/ \
/etc/vz \
/etc/logrotate.d/vzctl \
/var/log/apache2/${HUBNAME}-access.log* 

# now create the tar file that is composed of all the other components

tar zcf "$STORE/$HZ" $PACKAGES $FILES $DB $WEBSITE $LDAP > /dev/null 2>&1

# the file transfer to wherever will take this form as we've disabled ssh, just allowing sftp (not scp)
# echo "put ./f1" | sftp -b - -i hz_backup_rsa hzbackup@somehost.somewhere > /dev/null
# ie pipe an sftp command to -b - so that it goes there.
#
# note that on the backup host, /etc/ssh/sshd_config has the following lines to only permit the SFTP login by pubkey
#Subsystem sftp internal-sftp
#Match group sftponly
#	ForceCommand internal-sftp
#	PasswordAuthentication no
#	AuthorizedkeysFile /home/hzbackup/.ssh/authorized_keys
#Match


# this is the key we need: (the variable above has manual newline chars which cause a space at the next line - remove it here)
echo $BACKUPKey | sed -e 's/^ //g' > $STORE/tmp_key
chmod 600 $STORE/tmp_key

#echo "put $STORE/$HZ" | sftp -b - -i $STORE/tmp_key $BACKUPUser@$BACKUPHost > /dev/null

# delete the key
rm -f $STORE/tmp_key

# and the store
#rm -r $STORE
