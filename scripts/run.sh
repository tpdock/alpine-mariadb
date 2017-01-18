#!/bin/sh

if [ -d "/run/mysqld" ]; then
	chown -R mysql:mysql /run/mysqld
else
	echo "[i] mysqld not found, creating...."
	mkdir -p /run/mysqld
	chown -R mysql:mysql /run/mysqld
fi

MYSQL_DATADIR=${MYSQL_DATADIR:-"/var/lib/mysql"}
MYSQL_DATABASE=${MYSQL_DATABASE:-""}
MYSQL_USER=${MYSQL_USER:-""}
MYSQL_PASSWORD=${MYSQL_PASSWORD:-""}

mkdir -p "$MYSQL_DATADIR/mysql"
chown -R mysql:mysql $MYSQL_DATADIR

if [ -d /var/lib/mysql/mysql ]; then
	echo "[i] MySQL directory already present, skipping creation"	
else
	echo 'Initializing database'
	mysql_install_db --user=mysql --datadir="$MYSQL_DATADIR" --rpm
	echo 'Database initialized'

	tfile=`mktemp`
	if [ ! -f "$tfile" ]; then
	    return 1
	fi

	cat << EOF > $tfile
USE mysql;
SET @@SESSION.SQL_LOG_BIN=0 ;
FLUSH PRIVILEGES ;
CREATE USER 'root'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}' ;
GRANT ALL ON *.* TO 'root'@'%' WITH GRANT OPTION ;
DROP DATABASE IF EXISTS test ;
CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}' ;
CREATE USER '${MYSQL_USER}'@'localhost' IDENTIFIED BY '${MYSQL_PASSWORD}' ;
EOF

	if [ "$MYSQL_DATABASE" != "" ]; then
	    echo "[i] Creating database: $MYSQL_DATABASE"
	    echo "CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\` CHARACTER SET utf8 COLLATE utf8_general_ci;" >> $tfile

	    if [ "$MYSQL_USER" != "" ]; then
		echo "[i] Creating user: $MYSQL_USER with password $MYSQL_PASSWORD"
		echo "GRANT ALL PRIVILEGES ON \`$MYSQL_DATABASE\`.* to '$MYSQL_USER'@'%' identified by '${MYSQL_PASSWORD}' ;" >> $tfile
		echo "GRANT ALL PRIVILEGES ON \`$MYSQL_DATABASE\`.* to '$MYSQL_USER'@'localhost' identified by '${MYSQL_PASSWORD}' ;" >> $tfile
		echo "FLUSH PRIVILEGES ;" >> $tfile
	    fi
	fi

	/usr/bin/mysqld --user=mysql --bootstrap --verbose=1 --datadir="$MYSQL_DATADIR" < $tfile
    rm -f "$tfile"
fi

exec /usr/bin/mysqld --user=mysql --console --datadir="$MYSQL_DATADIR"