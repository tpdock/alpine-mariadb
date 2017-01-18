FROM alpine:3.5

RUN apk --update add mariadb mariadb-client && rm -f /var/cache/apk/*

ADD scripts/run.sh /scripts/run.sh

RUN chmod -R 755 /scripts    

VOLUME /var/lib/mysql

ENTRYPOINT ["/scripts/run.sh"]

EXPOSE 3306