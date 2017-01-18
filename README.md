# MariaDB image running on Alpine Linux

## Features

  * MariaDB Version 10.1.20

## Creating an instance

```bash
docker run -it --name mariadb -p 3306:3306 -v /var/lib/mysql:/var/lib/mysql -e MYSQL_DATABASE=test -e MYSQL_USER=test -e MYSQL_PASSWORD=test -e MYSQL_ROOT_PASSWORD=test -e MYSQL_DATAIDIR=/var/lib/mysql tpdock/alpine-mariadb:10.1

```


## Available configuration environments:

### Main MariaDB parameters:
* `MYSQL_DATABASE`: database name
* `MYSQL_USER`: specific user
* `MYSQL_PASSWORD`: user password
* `MYSQL_ROOT_PASSWORD`: root password
* `MYSQL_DATADIR`: path, where mariadb data will be placed

Using the `--tmpfs` docker run option you can place the DB in tmpfs/ram:

--tmpfs "/var/lib/mysql:rw,size=300448k,mode=1777"