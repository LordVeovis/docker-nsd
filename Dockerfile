FROM alpine:3.19

LABEL description "Simple DNS authoritative server with DNSSEC support" \
      maintainer="Veovis <veovis@kveer.fr>"

ARG NSD_VERSION=4.7.0
ENV UID=991 GID=991

RUN set -xe; \
   install -d /var/db/nsd -o 991 -g 991 -m 755; \
   addgroup -S -g $GID nsd; \
   adduser -S -D -h /var/db/nsd -G nsd -u $UID -g nsd nsd; \
   apk add --no-cache nsd ca-certificates openssl ldns-tools

COPY entrypoint.sh /sbin/entrypoint.sh
COPY bin /usr/local/bin

VOLUME /zones /etc/nsd /var/db/nsd
EXPOSE 53 53/udp
ENTRYPOINT [ "/sbin/entrypoint.sh" ]
CMD nsd -u $UID.$GID -P /run/nsd.pid -d
