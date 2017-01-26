docker run --name alpine-mariadb -itd -e MYSQL_DATABASE=tposs -e MYSQL_USER=tposs -e MYSQL_PASSWORD=tposs  -e MYSQL_DATADIR=/dev/mysql -p 3306:3306 tpdock/alpine-mariadb:10.1
